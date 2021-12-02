pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    
    function Lottery() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted { // Usamos o restricted modifier

        uint index = random() % players.length;
        players[index].transfer(this.balance); // this = este contrato; balance = quantidade de money
        players = new address[](0); // creates new dinamic array of type address; (0) = tamanho do array com elementos do tipo address
    }

    modifier restricted() {   // Caso queiramos aplicar a mesma lógica para várias funções
        require(msg.sender == manager);
        _; // = run the rest of the code inside the function
    }
    
    function getPlayers() public view returns (address[]) {
        return players;
    }
}   