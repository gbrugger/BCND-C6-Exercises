pragma solidity ^0.4.25;

contract ExerciseC6A {
    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    bool private active = true;
    mapping(uint256 => mapping(address => bool)) private approvedBy;
    uint8 approvedCount = 0;
    uint8 approvedM = 3;
    uint256 currentApprovalIndex = 0;

    address private contractOwner; // Account used to deploy contract
    mapping(address => UserProfile) userProfiles; // Mapping for storing user profiles

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
     * @dev Constructor
     *      The deploying account becomes contractOwner
     */
    constructor() public {
        contractOwner = msg.sender;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
     * @dev Modifier that requires the "ContractOwner" account to be the function caller
     */
    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireActive() {
        require(active, "Contract not active.");
        _;
    }

    modifier requireIsAdmin() {
        require(isUserAdmin(msg.sender), "User is not admin.");
        _;
    }

    modifier requireConsensus() {
        require(
            approvedBy[currentApprovalIndex][msg.sender] == false,
            "User already approved."
        );

        approvedBy[currentApprovalIndex][msg.sender] = true;
        approvedCount++;
        if (approvedCount == approvedM) {
            approvedCount = 0;
            currentApprovalIndex++;
            _;
        }
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
     * @dev Check if a user is registered
     *
     * @return A bool that indicates if the user is registered
     */
    function isUserRegistered(address account) external view returns (bool) {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    function isUserAdmin(address account) public view returns (bool) {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isAdmin;
    }

    function setActive() public requireIsAdmin requireConsensus {
        active = !active;
    }

    function isActive() public view returns (bool) {
        return active;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser(
        address account,
        bool isAdmin
    ) external requireContractOwner requireActive {
        require(
            !userProfiles[account].isRegistered,
            "User is already registered."
        );

        userProfiles[account] = UserProfile({
            isRegistered: true,
            isAdmin: isAdmin
        });
    }
}
