const { expect } = require("chai");
const { web3 } = require("hardhat");
const copyrightToken = artifacts.require("CopyrightToken");

describe("CopyrightToken", function () {
    let deployer, addr1, addr2, addr3, CopyrightToken;
    
    beforeEach(async function () {
        [deployer, addr1, addr2, addr3] = await web3.eth.getAccounts();
        CopyrightToken = await copyrightToken.new();
    });

    describe("Deployment", function () {
        it("should construct ERC721", async function () {
            console.log(await CopyrightToken.name());
            console.log(await CopyrightToken.symbol());
            expect(await CopyrightToken.name()).to.equal("Test Copyright Token");
            expect(await CopyrightToken.symbol()).to.equal("TCT");
        })
    });

    describe("Mint copyright token", function () {
        it("should mint a token without providing parentIDs", async function () {
            await CopyrightToken.mint([], 1, {from: addr1});
            expect(await CopyrightToken.tokenCount().toNumber()).to.equal(1);
        })
    });


});