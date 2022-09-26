import hre from "hardhat";
import ethers from "ethers";
import { deployMockContract, MockContract } from "ethereum-waffle";

describe("Mintable Token With PoR", () => {
  let exampleTokenWithPoR: ethers.Contract
  let chainlinkPoRFeed: MockContract;
  let accountOne: ethers.Signer
  let accountTwo: ethers.Signer

  before(async () => {
    const [accOne, accTwo] = await hre.ethers.getSigners()

    accountOne = accOne
    accountTwo = accTwo

    const aggregatorV3Artifact = await hre.artifacts.readArtifact(
      "AggregatorV3Interface"
    ); 
    chainlinkPoRFeed = await deployMockContract(
      accOne,
      aggregatorV3Artifact.abi
    );

    await chainlinkPoRFeed.mock.decimals.returns(18)

    const MintableTokenWithPoR = await hre.ethers.getContractFactory("MintableTokenWithPoR")

    exampleTokenWithPoR = await MintableTokenWithPoR.deploy(
      chainlinkPoRFeed.address,
      3600 * 24 // 1 day
    )
  })

  it("Mint token", async () => {
    const currBlockNum = await hre.ethers.provider.getBlockNumber();
    const currBlock = await hre.ethers.provider.getBlock(currBlockNum);

    await chainlinkPoRFeed.mock.latestRoundData.returns(
      10000,
      hre.ethers.BigNumber.from(1000).pow(18),
      10000,
      currBlock.timestamp,
      100000
    )

    await exampleTokenWithPoR.mint(
      accountOne.getAddress(),
      hre.ethers.BigNumber.from(1).pow(18)
    )
  })
})
