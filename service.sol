pragma solidity >=0.7.0 <0.9.0;

contract PayPerService {

    struct service {
       
        address owner;
        uint amount;

        uint timestamp;
        uint expirationTime;

        uint interestAmount;
        uint viewers;

   }

    struct message {

        string message;
        uint code;

    }

    struct paidService {

        address owner;
        address payee;
        uint amount;

        bool paid;

    }

    mapping(address => service) public services; 

    mapping(address => message) private messages; 

    mapping(address => paidService) public paidServices;


    function newService(
        uint amount,
        uint expirationTime,
        uint interestAmount,
        string memory message,
        uint code,
        uint viewers

    ) public {
        services[msg.sender].owner = msg.sender;
        services[msg.sender].amount = amount;
        services[msg.sender].timestamp = block.timestamp;
        services[msg.sender].expirationTime = expirationTime;
        services[msg.sender].interestAmount = interestAmount;
        services[msg.sender].viewers = viewers;

        messages[msg.sender].message = message;
        messages[msg.sender].code = code;

    }


    function payService(address owner) public payable {

            uint payment;

            payment = services[owner].amount;

            require(msg.value >= payment);

            paidServices[msg.sender].payee = msg.sender;
            paidServices[msg.sender].owner = owner;
            paidServices[msg.sender].amount = msg.value;
            paidServices[msg.sender].paid = true;

            // write owner message to user address

            string memory _message;
            uint _code;

            _message = messages[owner].message;
            _code = messages[owner].code;

            messages[msg.sender].message = _message;
            messages[msg.sender].code = _code;

        }


    function viewMessage() public view virtual returns (string memory) {

        require(paidServices[msg.sender].paid == true);

        return messages[msg.sender].message;

    }


}
