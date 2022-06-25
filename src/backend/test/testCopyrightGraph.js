const { expect } = require("chai");
const { web3 } = require("hardhat");
const copyrightGraph = artifacts.require("CopyrightToken");

describe("CopyrightToken", function () {
    let deployer, addr1, addr2, addr3, CopyrightGraph;
    
    beforeEach(async function () {
        [deployer, addr1, addr2, addr3] = await web3.eth.getAccounts();
        CopyrightGraph = await copyrightGraph.new();
    });

    describe("Deployment", function () {
        it("should construct ERC721", async function () {
            console.log(await CopyrightGraph.name());
            console.log(await CopyrightGraph.symbol());
            expect(await CopyrightGraph.name()).to.equal("Test Copyright Token");
            expect(await CopyrightGraph.symbol()).to.equal("TCT");
        })
    });
});