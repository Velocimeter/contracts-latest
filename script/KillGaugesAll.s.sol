// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import "forge-std/console2.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Voter} from "../contracts/Voter.sol";


contract KillGaugesAll is Script { 

//pairs
address constant	A	=	0xBd9f6a6E5Fe43e03F8eCdaa273EcaDd1F44825Dd	;
address constant	B	=	0x744c6f8abe326417D2b0e70d283889833eeAF029	;
address constant	C	=	0x006B764F1a38dd173Bbb9b73beF095De68E81571	;
address constant	D	=	0x5CbB5ed3C767d7BcC7f8796aCF37a9D181233A2f	;
address constant	E	=	0x5Ca4D3746e63d2A860198bd19D6853383610c0b4	;
address constant	F	=	0x9980365E6FD47aa91eA4039524d2156c6Fb65327	;
address constant	G	=	0x754AeD0D7A61dD3B03084d5bB8285D674D663703	;
address constant	H	=	0xc0C68f8381d74c7fB0CcB6Ce7500e64841F966D6	;
address constant	I	=	0xeA9047625A190fadC51F03975345949D7dbF2F3E	;
address constant	J	=	0x965503C0CEfA1C42789ffD7b23aBD70e3469622f	;
address constant	K	=	0x4031F455eDfbC025Fc4C81379A74c44a7d3592F5	;
address constant	L	=	0x1Bc3232FF3cA851d4aAfcF1dB40C63794Ee06dec	;
address constant	M	=	0x16fB6c0203d85ab1a1c17E0BC6513e75B5931557	;
address constant	N	=	0x1D4E33e07ddf9cc8EDB204102c3238b6A2c0e3fb	;
address constant	O	=	0x44724F2A542D9b7653923D87F17712b113FEB448	;
address constant	P	=	0x3714446C8dfFB48d587895F70F3a56E049e7E427	;
address constant	Q	=	0xac0Be90c2806D7e8962E954BF2f7879cCAa4FC72	;
address constant	R	=	0xe506707dF5fE9b2F6c0Bd6C5039fc542Af1eeB50	;
address constant	S	=	0x79926749309741ba9409F12C7173Fb776868F518	;
address constant	T	=	0x9D047638826096ec3AbCa3cda9973dB19C89a786	;
address constant	U	=	0x8FfB8094c54854bd1C3e8231D35C5b919eF12689	;
address constant	V	=	0x1f9AdfE106aA6220BCC898AE4B85d6F68d0aDbF5	;
address constant	W	=	0xaC2C49a475C8d3b79FBA2eBaFCB11eC45B271680	;
address constant	X	=	0x0df8eC4046b0ca072a3318d793C05f87E9C76d25	;
address constant	Y	=	0xa2f7ecE2f2A0ffd24889223dE9a8D8F4F8E3943F	;
address constant	Z	=	0x009b522b35AD579E3B1EAE044864AEF74196b077	;
address constant	AA	=	0xe86F5A4634966e434f54Af4B598417dB0BA524E7	;
address constant	BB	=	0x2dBFeB48dEaccBFf9b0a54dEd1BC172e135a809C	;
address constant	CC	=	0x814446a3DE677C9d5AFFE62e75d5f5ccfa25Db94	;
address constant	DD	=	0x5163787EFd02EB5523dA4415F93640369Bff0441	;
address constant	EE	=	0x7392c47d48b3794344500Ca4c61A824e13FA8693	;
address constant	FF	=	0xb3E0794b901000E472E4D76DfcDec5fE6285B141	;
address constant	GG	=	0x5cEd6533Ed0AefdC8D2761d1F6d3868889BAaBa1	;
address constant	HH	=	0x9A408eC2c41FADC0D73a61F46060E83fF864D2E6	;
address constant	II	=	0x04aEEacBB65B0A2B4599233afb8a9565A8780119	;
address constant	JJ	=	0x990add3C85bbdE17B83627437c7364fACCDdCcAa	;
address constant	KK	=	0xB1c9b1819dE6d3FAE468664C6Ebd4e38e233A6b4	;
address constant	LL	=	0x42E3294D7095e830359EF9bAbEcD478e9Aa79f3F	;
address constant	MM	=	0x2Cc24302fa019C5A8F252afC9A69fCfBB8Dd8D2F	;
address constant	NN	=	0x5c85cf7B0F9baC3884e6732ccb788A05E8B8e179	;
address constant	OO	=	0xA069AA071ebe51274e2c095D63Ba03Fe51D98e0A	;
address constant	PP	=	0xe21838bc84cc01bDD1fFd68F60E202a033859175	;
address constant	QQ	=	0x531aa71E2B01Db990B8B1f5d94fBfdc9FFc217B6	;
address constant	RR	=	0x6f00840f81C41DC2f7C6f81Eb2E3EaeA973DBF5f	;
address constant	SS	=	0x8929202a5D04126E0dF6ccc3C5C2796B610b8F10	;
address constant	TT	=	0xC9635B851c070c4Fa5207e8a3357aE8BDA80f8b8	;
address constant	UU	=	0x2267DAa9B7458F5cFE03d3485cc871800977c2c6	;
address constant	VV	=	0x96D976892c6f01Ab5c13E843B38BEe90C2238F03	;
address constant	WW	=	0x69aE6BE12B5A3E62D1713F6ddd6ce990964beBb9	;
address constant	XX	=	0x7e79E7B91526414F49eA4D3654110250b7D9444f	;
address constant	YY	=	0xA656BD82B3Ad80DACaC683aD2Cb508F5432dd429	;
address constant	ZZ	=	0xaa5dA094074d25CF09D823A08530c04ce2F00892	;
address constant	AAA	=	0x57E8eFA2639A4cA7069cD90f7e27092758271e6b	;
address constant	BBB	=	0x8bA9e75fb4214c03B8e8690e4B46A15992250189	;
address constant	CCC	=	0x5c87D41bc9Ac200a18179Cc2702D9Bb38c27d8fE	;
address constant	DDD	=	0x563C5377215E06e501C0F093012eE4b91D5F55D4	;
address constant	EEE	=	0xBf80fb03CE981a476B460885B04Dbef781A7366d	;
address constant	FFF	=	0x607d00c4e6d4AcC579d7e8A258c0C18BA829cC5C	;
address constant	GGG	=	0xfF5659f159feA6c9447172414f79b1b710bd07B7	;
address constant	HHH	=	0xa15EFE39f030Db4261c8cE3420A04e6ffb48F43A	;
address constant	iii	=	0xf89F1EebA543CC3766F41078DB563F6ac4c5f067	;
address constant	jjjkkk	=	0x2fD885C2e89A48D519B37631E3aC9C380969F8EF	;
address constant	lll	=	0x0c3B568B8D76273E4b8c7aE43Ea2CEd197B53bC8	;
address constant	Mmm	=	0x84c44850a2DD3351b3211E44015135D8f7fcA321	;
address constant	Nnn	=	0x08eAd624be770a58c19499B21fB53A055AF8e224	;
address constant	Ooo	=	0xddA6259A93649346535db8744502493ee023208D	;
address constant	Ppp	=	0x6CFba070E5ACC11dE7ec6ec6623425fbf2037563	;
address constant	Qqq	=	0x257B3C794E8b0b1ef2260E2747fFf354b70bb4C5	;
address constant	Rrr	=	0x48D9628e7F09742c78d1EE7b89b986bC65e91837	;
address constant	sss	=	0x88d577E3559e611FAa4e9e808E65e5F521b581E6	;
address constant	Ttt	=	0xC0598D91766B8E0db7B292336037b02554292cfB	;
address constant	Uuu	=	0x3ECD2BDbBE6db1D2075048C553579195AE9Ea71d	;
address constant	Vvv	=	0x85748e1441bb8C2C79c45109579221FF18f1596d	;
address constant	www	=	0x4ae856378217164b455d12B3420f2c1400480006	;
address constant	Xxx	=	0x7A184021B591f948247d6ca4213F6586Ea00C650	;
address constant	Yyy	=	0x46d1FEEfeeBC1F30DF78f7de60fbae917Cd615b0	;
address constant	Zzz	=	0xB4FDDc1Df9CCA17e26328316e94C9099aCbd3bF8	;
address constant	Aaaa	=	0xf73628177406aF55Dc6921c38F819c2Ace55f910	;
address constant	Bbbb	=	0x2ac9325E28DbF44b1F78dF9028bfe71750113b3F	;
address constant	Cccc	=	0xD622BE04Bc6c129EAa3915E33863c94123705678	;
address constant	Dddd	=	0x585B5D3E89617B64db992412e6f83A1e27B3F2C5	;
address constant	Eeee	=	0x14Ab02f88a1d9d239a3a3d4c98Bbec7131A62525	;
address constant	Ffff	=	0xbdc98c219E4eD84BfbE7d356eE8311c55157786A	;
address constant	Gggg	=	0x505fbc979451097C201c04D7E68E402564D9E11C	;
address constant	Hhhh	=	0x806C66817f5835a4D710919EE0fA4f13e697e787	;
address constant	Iiii	=	0x237F9c6d2BBeAcc91049710ac47e3eAc83cDC55c	;
address constant	Jjjj	=	0x04A68FD82344377d7c2Dc3CdfA8235c907805577	;
address constant	Kkkk	=	0x4a0b21b17285d38f09005dDab39438e11FdfDfDD	;
address constant	Llll	=	0x06CAfcE82b2ab4e9d52685B228a4bB2216c36Efc	;
address constant	mmmm	=	0x8E7C622BB3Ee18179789D8B7F8fA26EbB448f2Bd	;
address constant	Nnnn	=	0x31340590e186926bB9d01CB76f56abb3209Ab78d	;
address constant	oooo	=	0x1F20056B539366909c702bb93e1c65ED2878C9e2	;
address constant	pppp	=	0x91301DCc34344ED73a82E1F10d3Aa9235F40B4ce	;
address constant	Qqqq	=	0x72A4EE8e502B5aa3ef6b848a05cA3c323Ed6196d	;
address constant	Rrrr	=	0x228183e6C336CA5F7142b4F6a2538E3a5db97582	;
address constant	Ssss	=	0x8575d59C17c0aF03C49e91037cC1a6e6CB67d57C	;
address constant	Tttt	=	0x004cC4C45c60eF4b2F63ee71B04f76CA1dC0B23E	;
address constant	Uuuu	=	0x260052C4b885D28b6aA44FdFc9b5De17A91e5F05	;
address constant	Vvvv	=	0x7c7d1BD671C17199795f7eBE67E5d5283a012B58	;
address constant	wwww	=	0xd055DECd6aC73D7D70414468f451ea791cBE59F0	;
address constant	Xxxx	=	0x2602d4E5aA1A3f547f95F34f5dFdeec158c7E00b	;
address constant	Yyyy	=	0x36d8278949B8576D37F6Df0D41B452D935081504	;
address constant	Zzzz	=	0xBee8fBeb296a4DcD1BC18a4EFD01dCc4bAd94524	;
address constant	Asdf	=	0x7E282E6538163e7afb76027490486F59B3218310	;
address constant	Awe	=	0x4dF20b4854d61D2C1e1BFB76D66c3c7AFFb75401	;
address constant	Xxc	=	0xEa66945a563e96FBa3c0a463a747B466a30bF58F	;
address constant	Wer	=	0xEF5475C10C94D64FB386a47208a44A2901818bDB	;
address constant	Pdf	=	0xd3778B5aE193B1d916651F7049D3D0fb46f3e4D9	;
address constant	Xcv	=	0x931fDDa6450278672CebeF4b7100a64dE439623f	;
address constant	Ert	=	0x6E47AF7d7d7b1b71b601Ea055b1f812628A0bDCE	;
address constant	dfg	=	0x659F082680714DFca88beee7f956d2007E5103f3	;
address constant	Cab	=	0x397fA0B48aeE6F6206Ba8D4422268D38e71B22d7	;
address constant	Rty	=	0x582A99ED86a3d9b9AA8Aff5AdcceEE6f38e1c22A	;
address constant	fgh	=	0xe5Cb0a1e0be0c17CdE827E0372490D767495D6aF	;
address constant	Van	=	0x3A9692D8ED1c07E376FcB3Cd86783F5Be0629313	;
address constant	tyu	=	0xaFaf47626638F6249c53C346021B79754f1e97dc	;
address constant	ghj	=	0xE52D071568036DB68934566A18886E0eE6BFdA53	;
address constant	bnm	=	0x2501c056218F3C8F3c8B249bF4ddd941ae5642B4	;
address constant	Rio	=	0x84B72E9f23947493A595fd0609A3f4dA6B59405A	;
address constant	Hjk	=	0x617bfcf96EBBddD57e507191207346232E54d451	;
address constant	Top	=	0x858d1805303E4572188fa082c16b7f415a48f368	;
address constant	ewq	=	0x631B516B9B54E1AC1FfEA3919917fA598664951D	;
address constant	dsa	=	0x4eDBd1606Ab49e22846dd1EE2529E5FdA48FE062	;
address constant	Cuz	=	0xF94fc929f23A3853B4e1c7274cE4E6F2e485FEB9	;
address constant	Rew	=	0x9A2310444766FdE6316D183e2Bb1c39379E3a042	;
address constant	Fds	=	0x1086B26CF340801b26CA2DF58d20CE688Fd3E779	;
address constant	Bcc	=	0xB06eD5FE7C94467450a163D63F352F4A8F7eAa71	;



mapping(uint256 => address) pairs;
mapping(address => address) gauges;

    function makePairs() internal {

            pairs[	1	]	=	A	;
            pairs[	2	]	=	B	;
            pairs[	3	]	=	C	;
            pairs[	4	]	=	D	;
            pairs[	5	]	=	E	;
            pairs[	6	]	=	F	;
            pairs[	7	]	=	G	;
            pairs[	8	]	=	H	;
            pairs[	9	]	=	I	;
            pairs[	10	]	=	J	;
            pairs[	11	]	=	K	;
            pairs[	12	]	=	L	;
            pairs[	13	]	=	M	;
            pairs[	14	]	=	N	;
            pairs[	15	]	=	O	;
            pairs[	16	]	=	P	;
            pairs[	17	]	=	Q	;
            pairs[	18	]	=	R	;
            pairs[	19	]	=	S	;
            pairs[	20	]	=	T	;
            pairs[	21	]	=	U	;
            pairs[	22	]	=	V	;
            pairs[	23	]	=	W	;
            pairs[	24	]	=	X	;
            pairs[	25	]	=	Y	;
            pairs[	26	]	=	Z	;
            pairs[	27	]	=	AA	;
            pairs[	28	]	=	BB	;
            pairs[	29	]	=	CC	;
            pairs[	30	]	=	DD	;
            pairs[	31	]	=	EE	;
            pairs[	32	]	=	FF	;
            pairs[	33	]	=	GG	;
            pairs[	34	]	=	HH	;
            pairs[	35	]	=	II	;
            pairs[	36	]	=	JJ	;
            pairs[	37	]	=	KK	;
            pairs[	38	]	=	LL	;
            pairs[	39	]	=	MM	;
            pairs[	40	]	=	NN	;
            pairs[	41	]	=	OO	;
            pairs[	42	]	=	PP	;
            pairs[	43	]	=	QQ	;
            pairs[	44	]	=	RR	;
            pairs[	45	]	=	SS	;
            pairs[	46	]	=	TT	;
            pairs[	47	]	=	UU	;
            pairs[	48	]	=	VV	;
            pairs[	49	]	=	WW	;
            pairs[	50	]	=	XX	;
            pairs[	51	]	=	YY	;
            pairs[	52	]	=	ZZ	;
            pairs[	53	]	=	AAA	;
            pairs[	54	]	=	BBB	;
            pairs[	55	]	=	CCC	;
            pairs[	56	]	=	DDD	;
            pairs[	57	]	=	EEE	;
            pairs[	58	]	=	FFF	;
            pairs[	59	]	=	GGG	;
            pairs[	60	]	=	HHH	;
            pairs[	61	]	=	iii	;
            pairs[	62	]	=	jjjkkk	;
            pairs[	63	]	=	lll	;
            pairs[	64	]	=	Mmm	;
            pairs[	65	]	=	Nnn	;
            pairs[	66	]	=	Ooo	;
            pairs[	67	]	=	Ppp	;
            pairs[	68	]	=	Qqq	;
            pairs[	69	]	=	Rrr	;
            pairs[	70	]	=	sss	;
            pairs[	71	]	=	Ttt	;
            pairs[	72	]	=	Uuu	;
            pairs[	73	]	=	Vvv	;
            pairs[	74	]	=	www	;
            pairs[	75	]	=	Xxx	;
            pairs[	76	]	=	Yyy	;
            pairs[	77	]	=	Zzz	;
            pairs[	78	]	=	Aaaa	;
            pairs[	79	]	=	Bbbb	;
            pairs[	80	]	=	Cccc	;
            pairs[	81	]	=	Dddd	;
            pairs[	82	]	=	Eeee	;
            pairs[	83	]	=	Ffff	;
            pairs[	84	]	=	Gggg	;
            pairs[	85	]	=	Hhhh	;
            pairs[	86	]	=	Iiii	;
            pairs[	87	]	=	Jjjj	;
            pairs[	88	]	=	Kkkk	;
            pairs[	89	]	=	Llll	;
            pairs[	90	]	=	mmmm	;
            pairs[	91	]	=	Nnnn	;
            pairs[	92	]	=	oooo	;
            pairs[	93	]	=	pppp	;
            pairs[	94	]	=	Qqqq	;
            pairs[	95	]	=	Rrrr	;
            pairs[	96	]	=	Ssss	;
            pairs[	97	]	=	Tttt	;
            pairs[	98	]	=	Uuuu	;
            pairs[	99	]	=	Vvvv	;
            pairs[	100	]	=	wwww	;
            pairs[	101	]	=	Xxxx	;
            pairs[	102	]	=	Yyyy	;
            pairs[	103	]	=	Zzzz	;
            pairs[	104	]	=	Asdf	;
            pairs[	105	]	=	Awe	;
            pairs[	106	]	=	Xxc	;
            pairs[	107	]	=	Wer	;
            pairs[	108	]	=	Pdf	;
            pairs[	109	]	=	Xcv	;
            pairs[	110	]	=	Ert	;
            pairs[	111	]	=	dfg	;
            pairs[	112	]	=	Cab	;
            pairs[	113	]	=	Rty	;
            pairs[	114	]	=	fgh	;
            pairs[	115	]	=	Van	;
            pairs[	116	]	=	tyu	;
            pairs[	117	]	=	ghj	;
            pairs[	118	]	=	bnm	;
            pairs[	119	]	=	Rio	;
            pairs[	120	]	=	Hjk	;
            pairs[	121	]	=	Top	;
            pairs[	122	]	=	ewq	;
            pairs[	123	]	=	dsa	;
            pairs[	124	]	=	Cuz	;
            pairs[	125	]	=	Rew	;
            pairs[	126	]	=	Fds	;
            pairs[	127	]	=	Bcc	;
    }

    function makeGauges() internal {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);

            gauges[	A	] = voter.gauges(	A	);
            gauges[	B	] = voter.gauges(	B	);
            gauges[	C	] = voter.gauges(	C	);
            gauges[	D	] = voter.gauges(	D	);
            gauges[	E	] = voter.gauges(	E	);
            gauges[	F	] = voter.gauges(	F	);
            gauges[	G	] = voter.gauges(	G	);
            gauges[	H	] = voter.gauges(	H	);
            gauges[	I	] = voter.gauges(	I	);
            gauges[	J	] = voter.gauges(	J	);
            gauges[	K	] = voter.gauges(	K	);
            gauges[	L	] = voter.gauges(	L	);
            gauges[	M	] = voter.gauges(	M	);
            gauges[	N	] = voter.gauges(	N	);
            gauges[	O	] = voter.gauges(	O	);
            gauges[	P	] = voter.gauges(	P	);
            gauges[	Q	] = voter.gauges(	Q	);
            gauges[	R	] = voter.gauges(	R	);
            gauges[	S	] = voter.gauges(	S	);
            gauges[	T	] = voter.gauges(	T	);
            gauges[	U	] = voter.gauges(	U	);
            gauges[	V	] = voter.gauges(	V	);
            gauges[	W	] = voter.gauges(	W	);
            gauges[	X	] = voter.gauges(	X	);
            gauges[	Y	] = voter.gauges(	Y	);
            gauges[	Z	] = voter.gauges(	Z	);
            gauges[	AA	] = voter.gauges(	AA	);
            gauges[	BB	] = voter.gauges(	BB	);
            gauges[	CC	] = voter.gauges(	CC	);
            gauges[	DD	] = voter.gauges(	DD	);
            gauges[	EE	] = voter.gauges(	EE	);
            gauges[	FF	] = voter.gauges(	FF	);
            gauges[	GG	] = voter.gauges(	GG	);
            gauges[	HH	] = voter.gauges(	HH	);
            gauges[	II	] = voter.gauges(	II	);
            gauges[	JJ	] = voter.gauges(	JJ	);
            gauges[	KK	] = voter.gauges(	KK	);
            gauges[	LL	] = voter.gauges(	LL	);
            gauges[	MM	] = voter.gauges(	MM	);
            gauges[	NN	] = voter.gauges(	NN	);
            gauges[	OO	] = voter.gauges(	OO	);
            gauges[	PP	] = voter.gauges(	PP	);
            gauges[	QQ	] = voter.gauges(	QQ	);
            gauges[	RR	] = voter.gauges(	RR	);
            gauges[	SS	] = voter.gauges(	SS	);
            gauges[	TT	] = voter.gauges(	TT	);
            gauges[	UU	] = voter.gauges(	UU	);
            gauges[	VV	] = voter.gauges(	VV	);
            gauges[	WW	] = voter.gauges(	WW	);
            gauges[	XX	] = voter.gauges(	XX	);
            gauges[	YY	] = voter.gauges(	YY	);
            gauges[	ZZ	] = voter.gauges(	ZZ	);
            gauges[	AAA	] = voter.gauges(	AAA	);
            gauges[	BBB	] = voter.gauges(	BBB	);
            gauges[	CCC	] = voter.gauges(	CCC	);
            gauges[	DDD	] = voter.gauges(	DDD	);
            gauges[	EEE	] = voter.gauges(	EEE	);
            gauges[	FFF	] = voter.gauges(	FFF	);
            gauges[	GGG	] = voter.gauges(	GGG	);
            gauges[	HHH	] = voter.gauges(	HHH	);
            gauges[	iii	] = voter.gauges(	iii	);
            gauges[	jjjkkk	] = voter.gauges(	jjjkkk	);
            gauges[	lll	] = voter.gauges(	lll	);
            gauges[	Mmm	] = voter.gauges(	Mmm	);
            gauges[	Nnn	] = voter.gauges(	Nnn	);
            gauges[	Ooo	] = voter.gauges(	Ooo	);
            gauges[	Ppp	] = voter.gauges(	Ppp	);
            gauges[	Qqq	] = voter.gauges(	Qqq	);
            gauges[	Rrr	] = voter.gauges(	Rrr	);
            gauges[	sss	] = voter.gauges(	sss	);
            gauges[	Ttt	] = voter.gauges(	Ttt	);
            gauges[	Uuu	] = voter.gauges(	Uuu	);
            gauges[	Vvv	] = voter.gauges(	Vvv	);
            gauges[	www	] = voter.gauges(	www	);
            gauges[	Xxx	] = voter.gauges(	Xxx	);
            gauges[	Yyy	] = voter.gauges(	Yyy	);
            gauges[	Zzz	] = voter.gauges(	Zzz	);
            gauges[	Aaaa	] = voter.gauges(	Aaaa	);
            gauges[	Bbbb	] = voter.gauges(	Bbbb	);
            gauges[	Cccc	] = voter.gauges(	Cccc	);
            gauges[	Dddd	] = voter.gauges(	Dddd	);
            gauges[	Eeee	] = voter.gauges(	Eeee	);
            gauges[	Ffff	] = voter.gauges(	Ffff	);
            gauges[	Gggg	] = voter.gauges(	Gggg	);
            gauges[	Hhhh	] = voter.gauges(	Hhhh	);
            gauges[	Iiii	] = voter.gauges(	Iiii	);
            gauges[	Jjjj	] = voter.gauges(	Jjjj	);
            gauges[	Kkkk	] = voter.gauges(	Kkkk	);
            gauges[	Llll	] = voter.gauges(	Llll	);
            gauges[	mmmm	] = voter.gauges(	mmmm	);
            gauges[	Nnnn	] = voter.gauges(	Nnnn	);
            gauges[	oooo	] = voter.gauges(	oooo	);
            gauges[	pppp	] = voter.gauges(	pppp	);
            gauges[	Qqqq	] = voter.gauges(	Qqqq	);
            gauges[	Rrrr	] = voter.gauges(	Rrrr	);
            gauges[	Ssss	] = voter.gauges(	Ssss	);
            gauges[	Tttt	] = voter.gauges(	Tttt	);
            gauges[	Uuuu	] = voter.gauges(	Uuuu	);
            gauges[	Vvvv	] = voter.gauges(	Vvvv	);
            gauges[	wwww	] = voter.gauges(	wwww	);
            gauges[	Xxxx	] = voter.gauges(	Xxxx	);
            gauges[	Yyyy	] = voter.gauges(	Yyyy	);
            gauges[	Zzzz	] = voter.gauges(	Zzzz	);
            gauges[	Asdf	] = voter.gauges(	Asdf	);
            gauges[	Awe	] = voter.gauges(	Awe	);
            gauges[	Xxc	] = voter.gauges(	Xxc	);
            gauges[	Wer	] = voter.gauges(	Wer	);
            gauges[	Pdf	] = voter.gauges(	Pdf	);
            gauges[	Xcv	] = voter.gauges(	Xcv	);
            gauges[	Ert	] = voter.gauges(	Ert	);
            gauges[	dfg	] = voter.gauges(	dfg	);
            gauges[	Cab	] = voter.gauges(	Cab	);
            gauges[	Rty	] = voter.gauges(	Rty	);
            gauges[	fgh	] = voter.gauges(	fgh	);
            gauges[	Van	] = voter.gauges(	Van	);
            gauges[	tyu	] = voter.gauges(	tyu	);
            gauges[	ghj	] = voter.gauges(	ghj	);
            gauges[	bnm	] = voter.gauges(	bnm	);
            gauges[	Rio	] = voter.gauges(	Rio	);
            gauges[	Hjk	] = voter.gauges(	Hjk	);
            gauges[	Top	] = voter.gauges(	Top	);
            gauges[	ewq	] = voter.gauges(	ewq	);
            gauges[	dsa	] = voter.gauges(	dsa	);
            gauges[	Cuz	] = voter.gauges(	Cuz	);
            gauges[	Rew	] = voter.gauges(	Rew	);
            gauges[	Fds	] = voter.gauges(	Fds	);
            gauges[	Bcc	] = voter.gauges(	Bcc	);

    }

    function run() external {
        uint256 PrivateKey = vm.envUint("VOTE_PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);

        makePairs();
        makeGauges();
        uint256 currentPair = 1;
        uint256 maxPair = 127;
        while (currentPair <= maxPair){

            address gauge = gauges[pairs[currentPair]];    
            console2.log(gauge);
            // _killGauges(gauge);
            _isAlive(gauge);
            currentPair++;
        }

        vm.stopBroadcast();
    }


    function _killGauges(address _gauge) private {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);
        if (voter.isAlive(_gauge) == true){
            voter.killGauge(_gauge);
            console2.log(_gauge, "was killed");
            }
    }

    function _isAlive(address _gauge) private view {
        Voter voter = Voter(0x8e3525Dbc8356c08d2d55F3ACb6416b5979D3389);
          bool alive = voter.isAlive(_gauge);
          console2.log(_gauge, "is alive?", alive);
        }
}



