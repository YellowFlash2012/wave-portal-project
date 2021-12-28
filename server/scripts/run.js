const main = async () => {
    
    const waveContractFactory = await hre.ethers.getContractFactory(
        "WavePortal"
    );

    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    
    console.log("Contract addy:", waveContract.address);

    // get contract balance
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);

    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    // let waveCount;
    // waveCount = await waveContract.getTotalWaves();
    // console.log(waveCount.toNumber());

    // let's try 2 waves now
    const waveTxn = await waveContract.wave('This is wave #1');
    await waveTxn.wait(); //wait for transaction to be mined
    
    const waveTxn2 = await waveContract.wave('This is wave #2');
    await waveTxn2.wait(); //wait for transaction to be mined

    // Get Contract balance to see what happened
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    // const [_, randomPerson] = await hre.ethers.getSigners();
    // getting a random person to wave at us
    // waveTxn = await waveContract.connect(randomPerson).wave('Another message');
    // await waveTxn.wait(); //wait for the transaction to be mined

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();
