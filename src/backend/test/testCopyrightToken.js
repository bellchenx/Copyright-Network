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
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(1);
            expect(await CopyrightToken.ownerOf(1)).to.equal(addr1);

            expect(await CopyrightToken.isIndependent(1)).to.equal(true);
            expect(await CopyrightToken.doAllowAdoption(1)).to.equal(false);
            expect(await CopyrightToken.doAllowDistribution(1)).to.equal(false);

        })

        it("should mint a token with providing parentIDs", async function () {
            await CopyrightToken.mint([], 1, {from: addr1});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(1);
            await CopyrightToken.changeAdoptionPermission(1, true, {from: addr1});

            await CopyrightToken.mint([1], 1, {from: addr2});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(2);
            expect(await CopyrightToken.ownerOf(2)).to.equal(addr2);
        })

        it("should mint a token with correct topology", async function () {
            // First token
            await CopyrightToken.mint([], 1, {from: addr1});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(1);
            await CopyrightToken.changeAdoptionPermission(1, true, {from: addr1});

            // Second token
            await CopyrightToken.mint([1], 1, {from: addr2});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(2);
            expect(await CopyrightToken.ownerOf(2)).to.equal(addr2);
            await CopyrightToken.changeAdoptionPermission(2, true, {from: addr2});

            // Third token
            await CopyrightToken.mint([1, 2], 1, {from: addr3});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(3);
            expect(await CopyrightToken.ownerOf(3)).to.equal(addr3);

            expect(await CopyrightToken.isIndependent(1)).to.equal(false);
            expect(await CopyrightToken.isIndependent(2)).to.equal(false);
            expect(await CopyrightToken.isIndependent(3)).to.equal(true);
        })

        it("should mint a token with correct weight", async function () {
            // First token
            await CopyrightToken.mint([], 1, {from: addr1});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(1);
            await CopyrightToken.changeAdoptionPermission(1, true, {from: addr1});

            // Second token
            await CopyrightToken.mint([1], 2, {from: addr2});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(2);
            expect(await CopyrightToken.ownerOf(2)).to.equal(addr2);

            
          
        })
    });


});