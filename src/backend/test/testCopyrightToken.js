const { expect } = require("chai");
const { web3, artifacts } = require("hardhat");
const copyrightToken = artifacts.require("CopyrightToken");
const nft = artifacts.require("ERC721CopyDistribution");


describe("CopyrightToken", function () {
    let deployer, addr1, addr2, addr3, CopyrightToken;
    
    beforeEach(async function () {
        [deployer, addr1, addr2, addr3] = await web3.eth.getAccounts();
        CopyrightToken = await copyrightToken.new();
    });

    describe("Deployment", function () {
        it("should construct ERC721", async function () {
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

        it("should mint a token with correct edge", async function () {
            // First token
            await CopyrightToken.mint([], 2, {from: addr1});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(1);
            await CopyrightToken.changeAdoptionPermission(1, true, {from: addr1});

            let token1 = await CopyrightToken.getToken(1);
            expect(token1.tokenWeight).to.equal("2");

            // Second token
            await CopyrightToken.mint([1], 2, {from: addr2});
            expect(await CopyrightToken.tokenCount().then(b => { return b.toNumber() })).to.equal(2);
            expect(await CopyrightToken.ownerOf(2)).to.equal(addr2);
            
            let token2 = await CopyrightToken.getToken(2);
            let edge = token2.edges[0];
            expect(await edge.to).to.equal("1");
            expect(await edge.weight).to.equal("2");
        })
    });

    describe("Distribute NFT from NFC", function () {
        it("should mint new ERC 721", async function () {
            await CopyrightToken.mint([], 1, {from: addr1});
            await CopyrightToken.changeDistributionPermission(1, true, {from: addr1});

            await CopyrightToken.setDistributionInfo(1, 'NFTTest', 'NFT', 'test', {from: addr1});
            await CopyrightToken.distributeCopies(1, {from: addr1});
            let nftAddr = await CopyrightToken.getDistributionToken(1);

            let distributionNFT = await nft.at(nftAddr);
            expect(await distributionNFT.contractURI()).to.equal("test");
        })
    })

});