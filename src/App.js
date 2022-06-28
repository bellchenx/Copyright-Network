import { useState, useEffect } from "react";

import Web3 from "web3";
import OverviewFlow from "./OverviewFlow.js"
import "./css/App.css";

import address from "./contractsData/CopyrightToken-address.json";
import abi from "./contractsData/CopyrightToken.json";

function App() {
  
  const [isConnected, setIsConnected] = useState(false);
  const [isLoading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  // Web3
  const [account, setAccount] = useState("");
  const [contract, setContract] = useState([]);

  // On-chain Info
  const [balance, setBalance] = useState(0);
  const [email, setEmail] = useState("");
  const [id, setID] = useState(0);
  const [referralNum, setReferralNum] = useState(0);

  let _contract,
    _account = "",
    _id,
    _referralNum,
    _refer = "",
    _email = "",
    web3;
    
  useEffect(() => {
    function checkConnectedWallet() {
      try {
        const userData = JSON.parse(localStorage.getItem("userAccount"));
        if (userData != null) {
          // onConnect();
        }
      } catch (err) {
        console.log(err);
      }
    }
    checkConnectedWallet();
  }, []);

  const onConnect = async () => {
    setLoading(true);
    try {
      // Load Web3
      const currentProvider = detectCurrentProvider();
      web3 = new Web3(currentProvider);
      const chainId = await web3.eth.getChainId();

      // Load Users
      const userAccount = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      if (userAccount.length === 0) {
        setErrorMessage("Please add an account to the MetaMask.");
        return;
      }
      _account = userAccount[0];
      setAccount(_account);

      // Load ETH Balances
      let ethBalance = await web3.eth.getBalance(_account); // Get wallet balance
      ethBalance = web3.utils.fromWei(ethBalance, "ether"); //Convert balance to wei
      setBalance(ethBalance);

      // Save User Info
      saveUserInfo(ethBalance, _account, chainId);

      // Load Contract and On-chain Info
      await loadContract();

      // Set Reload
      window.ethereum.on("accountsChanged", function () {
        onConnect();
      });
      window.ethereum.on("chainChanged", function () {
        onConnect();
      });
      setIsConnected(true);
    } catch (err) {
      setErrorMessage(
        "There was an error loading. Make sure your Ethereum client is configured correctly."
      );
      console.log(err);
    }
    setLoading(false);
  };

  const loadContract = async() => {
    const addressJson = address.address;
    const abiJson = abi.abi;
    _contract = await new web3.eth.Contract(abiJson, addressJson);
    setContract(_contract);
  };

  const saveUserInfo = (ethBalance, account, chainId) => {
    const userAccount = {
      account: account,
      balance: ethBalance,
      connectionid: chainId,
    };
    window.localStorage.setItem("userAccount", JSON.stringify(userAccount)); //user persisted data
  };

  const detectCurrentProvider = () => {
    try {
      let provider;
      if (window.ethereum) {
        provider = window.ethereum;
      } else {
        setErrorMessage("No Web3 wallet detected.");
      }
      return provider;
    } catch (err) {
      setErrorMessage("No Web3 wallet detected.");
    }
  };

  const mint = async() => {
    console.log(account);
    await contract.methods.mint([], 100).send({from: account});
  };

  const distribute = async() => {
    console.log(await contract.methods.distributeCopies(2).send({from: account}));
  };

  return (
    <div className="App">
      <div className="react-container">
        {isConnected ? (
          <div style={{ height: 1000 }}>
            <button onClick={mint}>mint copyright</button>
            <br/>
            <button onClick={distribute}>distribute NFT copy</button>
            <OverviewFlow />
          </div>
        ) : (
          <div>
            <button className="btn-react" onClick={onConnect}>
              Connect Wallet
            </button>
            {errorMessage && (
              <div className="error">
                <br />
                <p>{errorMessage}</p>
                <a
                  href="https://www.geeksforgeeks.org/how-to-install-and-use-metamask-on-google-chrome/"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Setup Instruction
                </a>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
