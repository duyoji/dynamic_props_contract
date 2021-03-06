const Monster = artifacts.require("./Monster.sol");

// Use latest web3 instead of using old one built-in truffle.
const Web3latest = require('web3');
const web3latest = new Web3latest();

module.exports = async function(deployer) {
  const keys = ['id', 'name', 'type', 'rarity'].map(key => web3latest.utils.utf8ToHex(key));
  const values = ['1', 'モンス', 'Fire', 'SSS'].map(value => web3latest.utils.utf8ToHex(value)); // Dummy data

  console.log(keys.map(web3latest.utils.hexToUtf8));

  deployer.deploy(Monster, keys);
  const monster = Monster.at(Monster.address);
  await monster.updateProps(keys, values);


  console.log('keys====================================');
  const keysFromMethod = await monster.getAllProps();
  console.log('hex keys : ', keysFromMethod);
  console.log('utf8 keys : ', keysFromMethod.map(web3latest.utils.hexToUtf8));

  console.log('value===================================');
  const hexValuesPromises = keysFromMethod.map(key => {
    return monster.props(key);
  });
  const hexValues = await Promise.all(hexValuesPromises);
  const utf8Values = hexValues.map(web3latest.utils.hexToUtf8);
  console.log('hex values : ', hexValues);
  console.log('utf8 values : ', utf8Values);
};
