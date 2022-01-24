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

    mapping(address => message) private serviceMessage; 

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

        serviceMessage[msg.sender].message = message;
        serviceMessage[msg.sender].code = code;

        services[msg.sender].viewers = viewers;

    }


    function payService(address owner) public payable {

            uint payment;

            payment = services[owner].amount;

            require(msg.value >= payment);

            paidServices[msg.sender].payee = msg.sender;
            paidServices[msg.sender].owner = owner;
            paidServices[msg.sender].amount = msg.value;
            paidServices[msg.sender].paid = true;



            

        }


    function viewMessage() public returns (string memory) {

        address owner;
        string memory _message;
        //uint code;
        
        require(paidServices[msg.sender].paid == true);

        owner = paidServices[msg.sender].owner;
        _message = serviceMessage[owner].message;

        return _message;

    }


}
