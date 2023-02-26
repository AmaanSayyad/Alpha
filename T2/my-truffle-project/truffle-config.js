const HDWalletProvider = require('truffle-hdwallet-provider');

const mnemonic = "your mnemonic phrase here";

module.exports = {
  networks: {
    kovan: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://kovan.infura.io/v3/your-project-id");
      },
      network_id: 42,
      gas: 8000000,
    }
  }
};
