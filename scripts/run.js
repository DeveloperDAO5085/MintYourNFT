const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnNFT();
    await txn.wait();

    txn = await nftContract.makeAnNFT();
    await txn.wait();
}

const runMain = async () => {
    try {
        await main();
        process.exit(1);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();