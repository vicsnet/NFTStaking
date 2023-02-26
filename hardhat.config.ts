import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
dotenv.config()

const config: HardhatUserConfig = {
  solidity: "0.8.17",
networks:{
  goerli:{
    url:process.env.GOERLI_RPC,
  // @ts-ignore
    accounts:[ process.env.PRIVATEKEY1],
  },
  hardhat: {
    forking: {
      url: "https://eth-mainnet.g.alchemy.com/v2/7KPCNan56WStQo-fHWWtuuX9qIXxRGio",
    }
  }
}
};

export default config;
