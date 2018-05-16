pragma solidity ^0.4.18;

contract Monster {
    bytes32[] public propKeys;
    mapping(bytes32 => bytes32) public props;
    mapping(bytes32 => bool) existsGuards;

    function Monster(bytes32[] _propKeys) public {
        for(uint i = 0; i < _propKeys.length; i++) {
            existsGuards[_propKeys[i]] = true;
        }
        propKeys = _propKeys;
    }

    modifier validKey(bytes32 _key) {
        require(existsGuards[_key]);
        _;
    }

    modifier validKeys(bytes32[] _keys) {
        require(_keys.length > 0);
        for(uint i = 0; i < _keys.length; i++) {
            require(existsGuards[_keys[i]]);
        }
        _;
    }

    function getAllProps() public view returns (bytes32[]) {
        return propKeys;
    }

    function updateProp(bytes32 _key, bytes32 _value) public validKey(_key) {
        props[_key] = _value;
    }

    /**
     * Update multiple values in props.
     *
     * @dev Each element in same index in both array is should be correspond.
     * e.g: _keys => ["type", "rarity"], _values => ["value for type", "value for rarity"]
     * @notice You can set only byte32 values because it is not allowed to use array of string(string[]) in solidity.
     * @param _keys An array of keys for props variable in storage and it should be same length with param of "_values"
     * @param _values An array of values for props variable and it should be same length with param of "_keys"
     */
    function updateProps(bytes32[] _keys, bytes32[] _values) public validKeys(_keys) {
        require(_keys.length == _values.length);
        for(uint i = 0; i < _keys.length; i++) {
            updateProp(_keys[i], _values[i]);
        }
    }
}
