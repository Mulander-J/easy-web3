const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('EpicGame');
    const gameContract = await gameContractFactory.deploy(                     
      // Names
      ["Black Express", "Hikarian Nozomi", "Nankai Lapito", "Dr.Yellow"],
      // Images
      [
        "QmXRtZaaBwNfySyEKDbAyEUam8XhpYhJ5mHidezGbMoAgj",
        "QmQpA4jDrMxCHdhMospdPtPyB7CYPzhXPMrS7MBAgqWfEt",
        "QmdPxKdU6Z3CHEdKBqiavTkuDfwzigpkpBRehgUfQqmdNC",
        "QmPTUAAp8MemNEf3U5KumWmS2yVqPQUKcBE9QcBLuHZEjB"
      ],
      // Intros
      [
        'The boss of the Blatcher Gang. He uses an electric maces and most times hides in black smoke.',
        "The most dynamic hero of the entire Hikarian members. He is full of fighting spirit. He uses a shield and sword.",
        "A ninja Hikarian. He uses a ninja sword with a shuriken shield. His attacks are super fast and ninja style.",
        'An engineer of Hikarian Headquarters. He assists Dr. 300X.'
      ]         
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);  
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