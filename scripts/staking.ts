import { ethers } from "hardhat";

async function main() {
    const NFTSTAKING = await ethers.getContractFactory("NFTStaking");
    const BoredApeContract = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D";

    const usdcContract = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

    const nftStaking = await NFTSTAKING.deploy(BoredApeContract,usdcContract);
    
    await nftStaking.deployed();
    console.log(`NFT Staking Contract Address is ${nftStaking.address}`)
    // const nftStaking = await ethers.getContractAt("NFTStaking", "0xD2D5e508C82EFc205cAFA4Ad969a4395Babce026")


    // APE HOLDER
    const ApeHolder1 = "0xe785aAfD96E23510A7995E16b49C22D15f219B85";     
    const ApeHolder2 ="0x4A385286592C97e457A6f54A3734557F4b095A28";
    
    
    // connecting the BoredApe
    const ApeConnect = await ethers.getContractAt("IERC721", BoredApeContract);
     const apeBalance = await ApeConnect.balanceOf(ApeHolder1);
     console.log(`you Ape NFT Balance is ${apeBalance}`);

    //  connecting the USDC
    const USDCConnect = await ethers.getContractAt("IERC20",usdcContract);
    const usdcBalance = await USDCConnect.balanceOf(ApeHolder1);
    console.log(`your usdc balance is 1 ${usdcBalance}`);

    //  impersonating the Ape Holder
const helpers = require("@nomicfoundation/hardhat-network-helpers");
await helpers.impersonateAccount(ApeHolder1);
const impersonatedSigner = await ethers.getSigner(ApeHolder1);

const stakeToken = ethers.utils.parseEther("50");
 await USDCConnect.connect(impersonatedSigner).approve(nftStaking.address, 350000000  );

  await nftStaking.connect(impersonatedSigner).stake(50000);

  console.log(await USDCConnect.balanceOf(ApeHolder1));

  await ethers.provider.send("evm_mine", [1678048146]);

const calculateToken = await nftStaking.connect(impersonatedSigner).calculateToken();
console.log(await calculateToken)



}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  