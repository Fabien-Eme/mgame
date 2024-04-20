'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "3d55c0479f76fb5f3c3f34e6501c0b45",
"assets/AssetManifest.bin.json": "e16a0e3d95737b2707137c5a1e9bfa8c",
"assets/AssetManifest.json": "f0f8fb97106c1916c70c33e3e18a5764",
"assets/assets/audio/button.mp3": "b2da77acaaf315446c7ee96b7026736b",
"assets/assets/audio/button_back.mp3": "8a3380f4668846a94cadd913fa76e366",
"assets/assets/audio/Wallpaper.mp3": "67684b28487130b55045c8fcb4c3c332",
"assets/assets/fonts/AmaticSC-Bold.ttf": "fc2cf6f52e5e93d47948562ac011725b",
"assets/assets/fonts/Play-Bold.ttf": "6a82d0104d58be230604d30b6159322c",
"assets/assets/fonts/Play-Regular.ttf": "a83df317dd89c7dd5388a152a26b2236",
"assets/assets/icons/icon.png": "71bca7e4b90a013ca8752a9e576bcebf",
"assets/assets/images/achievements/cityCleaner.png": "c25a2f10d87aacfb045ccdba853b92aa",
"assets/assets/images/achievements/garbageCollector.png": "3a87613f8b40a63234364d676ffba571",
"assets/assets/images/avatar/avatar_mouth_close.png": "d551a53f23767daa08419042d40986ce",
"assets/assets/images/avatar/avatar_mouth_open.png": "ad542924c52406c1d6d20fbb12609b20",
"assets/assets/images/avatar/avatar_mouth_wide_open.png": "7fa73de2caf0f75e924d405cef122e89",
"assets/assets/images/buildings/belt_SN.png": "f4dd15a899d5d95b8c21340444fb86c6",
"assets/assets/images/buildings/belt_WE.png": "cca93ef73c079afeba08d61a05b642be",
"assets/assets/images/buildings/buryer/buryer_0_E.png": "16e55d4a719c866401251c2c47dae593",
"assets/assets/images/buildings/buryer/buryer_0_N.png": "8b519633faf97c979f6b0a439dea0cdc",
"assets/assets/images/buildings/buryer/buryer_0_S.png": "97291a2639f43dd36684c92f0e65595e",
"assets/assets/images/buildings/buryer/buryer_0_W.png": "78c4ac2af036d6dce407d34eeda7e7d4",
"assets/assets/images/buildings/buryer/buryer_100_E.png": "3ded38901892ac7ec52d3d94b8f6e648",
"assets/assets/images/buildings/buryer/buryer_100_N.png": "b5df629b7058c1c4a2413ef3c1cc94dc",
"assets/assets/images/buildings/buryer/buryer_100_S.png": "f6d40810cc45fa4fef07a97eeb861ec3",
"assets/assets/images/buildings/buryer/buryer_100_W.png": "fd7260dc85422a5566f15fcc6c5eea48",
"assets/assets/images/buildings/buryer/buryer_25_E.png": "6ceebd80d4f0e805b2633b17ad06c739",
"assets/assets/images/buildings/buryer/buryer_25_N.png": "f22f67a249f6788c4d1043127e1a6ed1",
"assets/assets/images/buildings/buryer/buryer_25_S.png": "93bf7c6c1e2a97a09f2d628302210405",
"assets/assets/images/buildings/buryer/buryer_25_W.png": "52ce47d4cb5b01a02ac5a60a516bd3ee",
"assets/assets/images/buildings/buryer/buryer_50_E.png": "2c66384047f6b70252724269698e8994",
"assets/assets/images/buildings/buryer/buryer_50_N.png": "b3a9a3a82ad1a28f08a51e560e15e59a",
"assets/assets/images/buildings/buryer/buryer_50_S.png": "6fa1e96161dab7626674725d344fc74d",
"assets/assets/images/buildings/buryer/buryer_50_W.png": "c2217084db60866c5e61aa6e07e40c45",
"assets/assets/images/buildings/buryer/buryer_75_E.png": "3b243a27353e82431cc64d46a8f91b69",
"assets/assets/images/buildings/buryer/buryer_75_N.png": "7d7f2c182ea3c635d9cf309d5e3fe52b",
"assets/assets/images/buildings/buryer/buryer_75_S.png": "1f9b26dca380b903f8aee233eb8f6f71",
"assets/assets/images/buildings/buryer/buryer_75_W.png": "3fdd8023d42780035bc3e49a5e63f21d",
"assets/assets/images/buildings/buryer/buryer_outline_E.png": "0facf5fa13710a4ad1669a2de23c48fe",
"assets/assets/images/buildings/buryer/buryer_outline_N.png": "7d0fe5c6d3b645b5548da72ea140780e",
"assets/assets/images/buildings/buryer/buryer_outline_S.png": "00f165ec6c2e91a32dc4c6d518a90cbc",
"assets/assets/images/buildings/buryer/buryer_outline_W.png": "ca07385c3fb883a4f54a73f917985c3c",
"assets/assets/images/buildings/city/city_E.png": "9df9d7024df6d2e7aa2803613735662b",
"assets/assets/images/buildings/city/city_N.png": "620489440ada5986e970c0b2f89f610b",
"assets/assets/images/buildings/city/city_outline_E.png": "f4397549d9e2d8a66fe70aace574996b",
"assets/assets/images/buildings/city/city_outline_N.png": "de00e9a4e9c4ae589d113709c1d3f5ec",
"assets/assets/images/buildings/city/city_outline_S.png": "3e7eee6905b97a4f9ff429add6b3931a",
"assets/assets/images/buildings/city/city_outline_W.png": "a8c764b273a6b2697d9101faf9b0e53a",
"assets/assets/images/buildings/city/city_S.png": "76c59282d126ab1af44ad39efa539b28",
"assets/assets/images/buildings/city/city_W.png": "9c424f66db977f530a55d08b3dae357f",
"assets/assets/images/buildings/empty.png": "375e403715f2371b01271d1de3168adf",
"assets/assets/images/buildings/garage/garage_E_back.png": "4bfe2a959f4f6050a0db1db0374f3d14",
"assets/assets/images/buildings/garage/garage_E_door_spritesheet.png": "fae23898b68485ba1949acf4f28715ea",
"assets/assets/images/buildings/garage/garage_E_front.png": "e63c37abc2a46e2fdfa655a1d2381519",
"assets/assets/images/buildings/garage/garage_N_front.png": "a07b780e4db078cd0e1399a500026282",
"assets/assets/images/buildings/garage/garage_outline_E.png": "2f116a0f4b02016ecfc346a180d60c8f",
"assets/assets/images/buildings/garage/garage_outline_N.png": "477ab1ad082096809b8e52a952a172bd",
"assets/assets/images/buildings/garage/garage_outline_S.png": "8068dc5255dd1c8b1e35af81dc22df33",
"assets/assets/images/buildings/garage/garage_outline_W.png": "4cc3bf69c5bce7e968b37feb263aade5",
"assets/assets/images/buildings/garage/garage_S_back.png": "2dba37a9a3fc785005546866038588d3",
"assets/assets/images/buildings/garage/garage_S_door_spritesheet.png": "2ec067745fa2191ac54f30412c960714",
"assets/assets/images/buildings/garage/garage_S_front.png": "51b30bfae7d357300cfdb1b661dc9389",
"assets/assets/images/buildings/garage/garage_W_front.png": "9f85385c7e154852265b9ed5c7d2d43e",
"assets/assets/images/buildings/garbage_conveyor/garbage_conveyor_back.png": "512d87b2efe81ea48baa8e6281b79fc9",
"assets/assets/images/buildings/garbage_conveyor/garbage_conveyor_front.png": "2e1aa921cfbd60c6c92db74b33879911",
"assets/assets/images/buildings/garbage_loader/garbage_loader_E_back.png": "e979a63965c533c2395dd369d978e758",
"assets/assets/images/buildings/garbage_loader/garbage_loader_E_FLOWE_spritesheet.png": "0c6b972693bed823df8b40ef3f1f66a6",
"assets/assets/images/buildings/garbage_loader/garbage_loader_E_FLOWW_spritesheet.png": "e42e31a4d33806ebd24311f91ee641c7",
"assets/assets/images/buildings/garbage_loader/garbage_loader_N_FLOWN_spritesheet.png": "06f25b04f0fbeecdde884d03c58ed016",
"assets/assets/images/buildings/garbage_loader/garbage_loader_N_FLOWS_spritesheet.png": "c79d0e2b946519064187945ae4d0a1f7",
"assets/assets/images/buildings/garbage_loader/garbage_loader_outline_E.png": "be6284f670bee114b974b6fecdf5c6d8",
"assets/assets/images/buildings/garbage_loader/garbage_loader_outline_S.png": "0ea1fe97109c8377f025fa6ff2301f3e",
"assets/assets/images/buildings/garbage_loader/garbage_loader_S_back.png": "a471756edf8eaec6416de5b4f0062cf7",
"assets/assets/images/buildings/garbage_loader/garbage_loader_S_FLOWN_spritesheet.png": "8dd614d5eda26513d488b8d98b80fb16",
"assets/assets/images/buildings/garbage_loader/garbage_loader_S_FLOWS_spritesheet.png": "35af023db0ec38c20cc3714931167aa1",
"assets/assets/images/buildings/garbage_loader/garbage_loader_W_FLOWE_spritesheet.png": "112421e7cdf296e3520273a2d1347036",
"assets/assets/images/buildings/garbage_loader/garbage_loader_W_FLOWW_spritesheet.png": "8e8a70c87b90d18cb41de89dde34c21b",
"assets/assets/images/buildings/incinerator/door_E_spritesheet.png": "69e282022a963c4846a51eb5ed96fc22",
"assets/assets/images/buildings/incinerator/door_S_spritesheet.png": "73dd40fc3241bdbcd49e4627d1fb7431",
"assets/assets/images/buildings/incinerator/incinerator_E_back.png": "9fca9e1bea5b93c89e9ba7bcce88cc51",
"assets/assets/images/buildings/incinerator/incinerator_E_front.png": "1f62a29bf24765d4b07e8855cf95f7fd",
"assets/assets/images/buildings/incinerator/incinerator_N_front.png": "7ebef461afc27311ce5af3d410eb227d",
"assets/assets/images/buildings/incinerator/incinerator_outline_E.png": "9f850652e58c91adaf3ca16f149d3787",
"assets/assets/images/buildings/incinerator/incinerator_outline_N.png": "0a6d5f84cba38d714b4d4d5b90490832",
"assets/assets/images/buildings/incinerator/incinerator_outline_S.png": "e50e8156757448a68e0eaece0dcc8893",
"assets/assets/images/buildings/incinerator/incinerator_outline_W.png": "212e25876827e2c137235890dcf43740",
"assets/assets/images/buildings/incinerator/incinerator_S_back.png": "36c065595a4ccdbe22baf123f46c6ec2",
"assets/assets/images/buildings/incinerator/incinerator_S_front.png": "35b2f7f11a6d7490559b5be913bbeab5",
"assets/assets/images/buildings/incinerator/incinerator_W_front.png": "afe9e42c2f6d4efe065b89319bce8c8b",
"assets/assets/images/buildings/recycler/recycler_E_back.png": "763004306dad8bcfe77b539378ba4011",
"assets/assets/images/buildings/recycler/recycler_E_front.png": "9c8d91e50baa46871ee6898e76f7a1eb",
"assets/assets/images/buildings/recycler/recycler_N_front.png": "e3b381152903d20fd35030e40edb3e03",
"assets/assets/images/buildings/recycler/recycler_outline_E.png": "c3bf6ced516a6402d1a0a6774293b6cf",
"assets/assets/images/buildings/recycler/recycler_outline_N.png": "149dc6dd141e46064b7fac7831264c3b",
"assets/assets/images/buildings/recycler/recycler_outline_S.png": "2277e728bef8498f28ac4ed5c21c29e3",
"assets/assets/images/buildings/recycler/recycler_outline_W.png": "3f145816281c85f0f67c7586a4ab1c8a",
"assets/assets/images/buildings/recycler/recycler_S_back.png": "33db263ac7868e84efecb42ac802d72e",
"assets/assets/images/buildings/recycler/recycler_S_front.png": "5f6f07254afa9ca9fc44554a847e991d",
"assets/assets/images/buildings/recycler/recycler_W_front.png": "fa8bb6ef5ab0f53dee65e895bdbbfb49",
"assets/assets/images/emote/emote_exclamation.png": "70047ff8876ec7993e115becfea473f9",
"assets/assets/images/pollution/smoke.png": "3d07335ae67f14bc979c2aa6834547f7",
"assets/assets/images/tiles/arrows/arrow_E.png": "4ff8e9294d1863a998d67f34b5e1bcd1",
"assets/assets/images/tiles/arrows/arrow_N.png": "720a63bb89da5245e1623caaae6921bf",
"assets/assets/images/tiles/arrows/arrow_S.png": "02d0dcc9450ec0e8f37fdb92b11cc272",
"assets/assets/images/tiles/arrows/arrow_W.png": "b52f27d50d756844363bd5244b97ded1",
"assets/assets/images/tiles/forest/forest_E.png": "ee774bfbb473a1f7e8cf8459db683390",
"assets/assets/images/tiles/forest/forest_N.png": "76631cb9a8a487fd0f87baa20972e15d",
"assets/assets/images/tiles/forest/forest_S.png": "6500bdb11e4339e5f51468f70f93a8c1",
"assets/assets/images/tiles/forest/forest_tile_1.png": "a8ca086f0b66466df8810c6fa869f005",
"assets/assets/images/tiles/forest/forest_tile_10.png": "ee0ce616f037b69b691d163810015a04",
"assets/assets/images/tiles/forest/forest_tile_11.png": "d5f7b877042a18b98083e49df23fc960",
"assets/assets/images/tiles/forest/forest_tile_12.png": "20983092f707498611681a4ecda503fb",
"assets/assets/images/tiles/forest/forest_tile_13.png": "5289dd80a8c6f1ca226497c34fb02a4f",
"assets/assets/images/tiles/forest/forest_tile_2.png": "f1e82377f5bc808a178fbb2e9f52e333",
"assets/assets/images/tiles/forest/forest_tile_3.png": "a0cee8e4731e43a860f01447b4b89c5f",
"assets/assets/images/tiles/forest/forest_tile_4.png": "4474e24b9277b394efdc7f56eb0d2b59",
"assets/assets/images/tiles/forest/forest_tile_5.png": "5afead7202dc038d169114a0e230ff65",
"assets/assets/images/tiles/forest/forest_tile_6.png": "ad70c7fe7ac45d570b202b4d31886357",
"assets/assets/images/tiles/forest/forest_tile_7.png": "bf4e78afe173b2f02499071db63d534b",
"assets/assets/images/tiles/forest/forest_tile_8.png": "399d4e3aa293ac0a1348e58651e8e5f8",
"assets/assets/images/tiles/forest/forest_tile_9.png": "6c8e0995f955fb53243a8e91df7ffc08",
"assets/assets/images/tiles/forest/forest_W.png": "e5639329ed98ff5da9b5408a63a1a078",
"assets/assets/images/tiles/grass.png": "4c96aa947ae589c75c27777d0ec7737b",
"assets/assets/images/tiles/road.png": "c8b6a849cf749c6df4ef4e169369649d",
"assets/assets/images/tiles/roadE.png": "282c8d492c1c958a63cd1ce5fd944709",
"assets/assets/images/tiles/roadN.png": "f8c854facd5605a885dfb3b7ae4fd808",
"assets/assets/images/tiles/roadS.png": "28a8b8a3f8c52df2c77b0a708cc00e8d",
"assets/assets/images/tiles/roadW.png": "bb50d460c0ef116fda3a3ef1caf9874a",
"assets/assets/images/tiles/road_ESW.png": "14584300f71eea9158f0d0c548a84a4e",
"assets/assets/images/tiles/road_NE.png": "a1e90bfdea907eada47e947c3a57053e",
"assets/assets/images/tiles/road_NES.png": "2543d99f9cf908c4daa4ea0252fea458",
"assets/assets/images/tiles/road_SE.png": "68bc5c728eee865d1e7719cda3a6a672",
"assets/assets/images/tiles/road_SN.png": "c2dce2558b45fe7d69f01065c25b1f22",
"assets/assets/images/tiles/road_SW.png": "5da178a43c54eea3c807a0bf03fa1a4e",
"assets/assets/images/tiles/road_SWN.png": "8386c24a1992452059befacf014545f8",
"assets/assets/images/tiles/road_SWNE.png": "30bcd8cb7bbd37ed459ef1e9787c8966",
"assets/assets/images/tiles/road_WE.png": "a7eb126489a6ecc5a8376f4cdcfc3096",
"assets/assets/images/tiles/road_WN.png": "894d237735565db6bb1cacf635d43701",
"assets/assets/images/tiles/road_WNE.png": "97ab20f6ace8ad1b79ab4277eb0325a3",
"assets/assets/images/trucks/stacked/truck_B_stacked.png": "a529202b77653dde63aeac86a49858fc",
"assets/assets/images/trucks/stacked/truck_P_stacked.png": "760d2389699aa48a24e584b6a3651086",
"assets/assets/images/trucks/stacked/truck_Y_stacked.png": "f1f6a635355cba2701b9ec4d8b789dbe",
"assets/assets/images/trucks/truck_B_00.png": "a56a53538543d73f6f50ffe94faa484f",
"assets/assets/images/trucks/truck_B_01.png": "f774e1c95b0fc4a2661c6730eeb1e1b0",
"assets/assets/images/trucks/truck_B_02.png": "009f5945dfdc36f7ea1113b4445f648b",
"assets/assets/images/trucks/truck_B_03.png": "a08eb4478c0bc9474439082f1bd8f3dc",
"assets/assets/images/trucks/truck_B_04.png": "daeb8f3949625ec13ef0c7af00f7f2ce",
"assets/assets/images/trucks/truck_B_05.png": "2c22376c6a0cad7b41c80d5b04966d7a",
"assets/assets/images/trucks/truck_B_06.png": "750363166d5eb6cda3a56a865c5438d5",
"assets/assets/images/trucks/truck_B_07.png": "aa52304448405a58f81c0aba11b0617c",
"assets/assets/images/trucks/truck_B_08.png": "8e509d8071c5d4605cf5733f82996539",
"assets/assets/images/trucks/truck_B_09.png": "b2deee7bff9281b6539a82a83c6afe87",
"assets/assets/images/trucks/truck_B_10.png": "0e117567d1f6e5c0f9dd5cb338bec98f",
"assets/assets/images/trucks/truck_B_11.png": "d8d4bf2fa542fb9de4a378ae318262b1",
"assets/assets/images/trucks/truck_B_12.png": "3c5dd44a5dd4d1e67ffb0f4eec4e55ed",
"assets/assets/images/trucks/truck_B_13.png": "6a511054a40cdfe792aa7f892c2b27a6",
"assets/assets/images/trucks/truck_B_14.png": "f7f02d31c0f0806d5c08de6b61870454",
"assets/assets/images/trucks/truck_B_15.png": "7ea3a0c39f682093faf4ac565079f875",
"assets/assets/images/trucks/truck_P_00.png": "9dadd4e9ebe3e28b2207fef956d5c3a2",
"assets/assets/images/trucks/truck_P_01.png": "9aa0578a1e25d8fb60b4daec0105050c",
"assets/assets/images/trucks/truck_P_02.png": "5f20f79508053cf9f90b72483915530f",
"assets/assets/images/trucks/truck_P_03.png": "155e3680ec2cb51ce077570781c1a5c7",
"assets/assets/images/trucks/truck_P_04.png": "5b6806df874a3db91f11a1f2b4435df3",
"assets/assets/images/trucks/truck_P_05.png": "b027e42820b95494974ce874e10f4422",
"assets/assets/images/trucks/truck_P_06.png": "7e6df29cc61e22d66b2618411f764fb5",
"assets/assets/images/trucks/truck_P_07.png": "97684bd23a4967a94234fec69bbcab41",
"assets/assets/images/trucks/truck_P_08.png": "e2dba168ee7df3f4382a62a1f3532c69",
"assets/assets/images/trucks/truck_P_09.png": "2f22dfdcbc6731445dd9b3063c7c9a6f",
"assets/assets/images/trucks/truck_P_10.png": "ea5c8d7e8231059cebcbf34ef6131283",
"assets/assets/images/trucks/truck_P_11.png": "885cf89355e5865711753140ab85622e",
"assets/assets/images/trucks/truck_P_12.png": "6595b09e212927db192ce42509276eba",
"assets/assets/images/trucks/truck_P_13.png": "1eada8f08e098c7bb6c75151a13df5a2",
"assets/assets/images/trucks/truck_P_14.png": "7b946bdd35e94d20881b808fa7763eeb",
"assets/assets/images/trucks/truck_P_15.png": "c95d4f86eeeb3762fc35553076846e8f",
"assets/assets/images/trucks/truck_Y_00.png": "91fcc0b809057943eb74eec01eb93729",
"assets/assets/images/trucks/truck_Y_01.png": "cc44034861d689b356c0262f3f41e4d4",
"assets/assets/images/trucks/truck_Y_02.png": "c8ab6aaeab800e7e1f7352aa12b3800b",
"assets/assets/images/trucks/truck_Y_03.png": "c6845cec5bc83af84bd388895c3d50df",
"assets/assets/images/trucks/truck_Y_04.png": "b99d059514a53bb6ccbddb040962b8a6",
"assets/assets/images/trucks/truck_Y_05.png": "654164d4dbccc5ba67a439b356fb492b",
"assets/assets/images/trucks/truck_Y_06.png": "02385b2daf738c2105dd638c8220ae4a",
"assets/assets/images/trucks/truck_Y_07.png": "aabe29dd1d0eaa9383079e6d7da09c65",
"assets/assets/images/trucks/truck_Y_08.png": "cb021c51be8d34fc204231f9b1ef8b25",
"assets/assets/images/trucks/truck_Y_09.png": "08e9c96b573ac2e502bebc22f7305b6e",
"assets/assets/images/trucks/truck_Y_10.png": "6d41b3dfa2d369c27529c03267f2af2e",
"assets/assets/images/trucks/truck_Y_11.png": "e3c4e5f52fcd6311ec742963229b6969",
"assets/assets/images/trucks/truck_Y_12.png": "c6f2a7876f70cb89232092ff588421ce",
"assets/assets/images/trucks/truck_Y_13.png": "a5b1a3dc81d4df7e70a4138728e0533c",
"assets/assets/images/trucks/truck_Y_14.png": "f6d34995ca5924efa704a6c9bbfeacd5",
"assets/assets/images/trucks/truck_Y_15.png": "3f4803de05f308e114f22266ffa41050",
"assets/assets/images/ui/add_to_google_wallet_button.png": "e421a43c1226fda9c5c6cfd8cc504d43",
"assets/assets/images/ui/dialog/audioOff.png": "fec88326f670d843943e8f1c306348a1",
"assets/assets/images/ui/dialog/audioOn.png": "350621842e23480adbcdeddf827d614d",
"assets/assets/images/ui/dialog/backward.png": "e0054f3793bf1a3ab660d4601c6e80d4",
"assets/assets/images/ui/dialog/close.png": "00da8ac1bd91efb0ae999f55505587c2",
"assets/assets/images/ui/dialog/complete.png": "49a036a100233d929cc037cbe52820cb",
"assets/assets/images/ui/dialog/complete_elevated.png": "a4614393ee2f65998b85700a9269ab9b",
"assets/assets/images/ui/dialog/complete_thick.png": "860dc191a8b4ab7d29011bbcfe5ecd9d",
"assets/assets/images/ui/dialog/complete_white.png": "087654efce9144b27be1dd78f1eaffed",
"assets/assets/images/ui/dialog/forward.png": "a37766aea690f0a99954d9a2e0db301e",
"assets/assets/images/ui/dialog/musicOff.png": "25381df3b7b972d3155d513a61aa794c",
"assets/assets/images/ui/dialog/musicOn.png": "aa68fd8f27df90fe90ad39e9f24f7185",
"assets/assets/images/ui/dialog/selector_cursor.png": "654f15f0bd612a35bfb10eb786f5674e",
"assets/assets/images/ui/dialog/selector_range_end.png": "3ce731375067a240f0d3e3cf9c6a96b5",
"assets/assets/images/ui/dialog/selector_range_middle_bar.png": "b1f5c4e762bb2318ad77c7534f79997a",
"assets/assets/images/ui/dialog/selector_range_middle_point.png": "05c7003f3b63f33e2364e03e9e4f61b3",
"assets/assets/images/ui/dialog/selector_range_start.png": "7575c83a3ec11dfc518cda147328d64a",
"assets/assets/images/ui/empty_garbage_processed_bar.png": "f5403683a24434d07e20fbd2e885caaa",
"assets/assets/images/ui/empty_pollution_bar.png": "645b00e723372d4c6043f9805dffaaee",
"assets/assets/images/ui/filled_garbage_processed_bar.png": "b8e6d4e9a85f2af394923e3f609d27d9",
"assets/assets/images/ui/filled_pollution_bar.png": "e4b955aa44542dcbb7d105bced29d262",
"assets/assets/images/ui/mouse_cursor.png": "48b2330573fbc1d603fc8a08ced1d0f6",
"assets/assets/images/ui/mouse_cursor_add.png": "b0491d95a399d617854d1454f8dba50a",
"assets/assets/images/ui/mouse_cursor_hand.png": "31097e4f119722540f6380c63d914378",
"assets/assets/images/ui/mouse_cursor_trash.png": "07c51114a9191b87cb5d6da48820eb62",
"assets/assets/images/ui/rotate_building.png": "62ed16a1ba2361defcaf736e360d1e49",
"assets/assets/images/ui/rotate_LEFT.png": "e5e7800ac0e130c5a51f60f9c3c85292",
"assets/assets/images/ui/rotate_RIGHT.png": "a86235ccdbf4c1817822a66c0e1b12f6",
"assets/assets/images/ui/settings.png": "0cccb8cc0717f9d18c07c8f0bc9a118e",
"assets/assets/images/ui/tile_cursor.png": "d840f504898e2c9a410c1d57ef9e3d18",
"assets/assets/images/ui/tile_cursor_background.png": "850bbff0bf221b8cdbcc5fe8f240dce9",
"assets/assets/images/ui/top_drawer.png": "b30b802f2433b168398e46f93df02154",
"assets/assets/images/ui/ui_buryer.png": "7c5fe0e55da514348ef1fb881bb9bb8a",
"assets/assets/images/ui/ui_button_green.png": "5b048a88ee2dd45532a7b867af7c7023",
"assets/assets/images/ui/ui_button_pressed_green.png": "4fdb6033ccc61664336b2f1a0c7bc897",
"assets/assets/images/ui/ui_button_pressed_red.png": "e90e6ddc3b6b06985233765523eb3828",
"assets/assets/images/ui/ui_button_pressed_white.png": "6ddafe3d6568cdf551f8072c3af0fdb9",
"assets/assets/images/ui/ui_button_red.png": "478dc1fa4100de8cb600c2c546bd6c5a",
"assets/assets/images/ui/ui_button_white.png": "585e7c6fb1586f21a1bf4afbc06c4c32",
"assets/assets/images/ui/ui_garbage_loader.png": "53f58020591942284af12fb356138f96",
"assets/assets/images/ui/ui_incinerator.png": "5ff0b65f7ecfc2cd6d02249a002a23cf",
"assets/assets/images/ui/ui_recycler.png": "04fce0845de4c9e88a1ca37ed31b7129",
"assets/assets/images/ui/ui_road_SN.png": "2452d0e66005efb8c0827ad4bdab0449",
"assets/assets/images/ui/ui_road_WE.png": "ebdebb95159d444bdc8da271e3a17fce",
"assets/assets/images/ui/ui_trash.png": "cfa61a8568f43eda796bcc565b6396f3",
"assets/assets/images/waste/garbage_can.png": "64e768e38aef929c74fb275777779b58",
"assets/assets/images/waste/garbage_can_small.png": "6e8dd578cd7167cf6c50f1912f54e4cc",
"assets/assets/images/waste/organic.png": "7cf22edfc07658bb42a6f933de961f92",
"assets/assets/images/waste/organic_small.png": "c9ddf014ac00b9cae43db6599b9d6352",
"assets/assets/images/waste/recyclable.png": "635778fccbe7048dda069245cc6a0148",
"assets/assets/images/waste/recyclable_small.png": "021a8a914e9efc33dffb6c7ffa09e4f2",
"assets/assets/images/waste/toxic.png": "a032bac68c36fbfd19191bcf198d6cfc",
"assets/assets/images/waste/toxic_small.png": "07eb6e3e7b5d5964cb91b435bb042ec7",
"assets/assets/images/waste/ultimate.png": "cf0197f6a54c1cbf0cab924e94c71a28",
"assets/assets/images/waste/ultimate_small.png": "0b18bf7a24c9f5278976323a4089d9a0",
"assets/FontManifest.json": "b2ae7223a066c01e7508bc7d8597ee87",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/NOTICES": "206f2ec755bc26b89414566cc99c2504",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "e78748ee717096f978b0cc4dcfaa3f33",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "bb4da79f227f2cdc00fef6d75af16049",
"icons/Icon-512.png": "6292b16fe8484f932a0203e091526618",
"icons/Icon-maskable-192.png": "bb4da79f227f2cdc00fef6d75af16049",
"icons/Icon-maskable-512.png": "6292b16fe8484f932a0203e091526618",
"index.html": "7da18a5800157266aec3e31b25f9f763",
"/": "7da18a5800157266aec3e31b25f9f763",
"main.dart.js": "0167b18904cc75cdc762ea144ce1be49",
"manifest.json": "ffc02785237d2633bbc94cb1f276574c",
"splash/img/dark-1x.png": "c239f8cc23313a8be94141d16daa0cc1",
"splash/img/dark-2x.png": "1d5a42f4cf75cbd15ff5ff118b970a1b",
"splash/img/dark-3x.png": "740fd28fbcbe01cf4531a7a64c2e55d5",
"splash/img/dark-4x.png": "cd8a8b898caee93527e4ec48148a1652",
"splash/img/light-1x.png": "c239f8cc23313a8be94141d16daa0cc1",
"splash/img/light-2x.png": "1d5a42f4cf75cbd15ff5ff118b970a1b",
"splash/img/light-3x.png": "740fd28fbcbe01cf4531a7a64c2e55d5",
"splash/img/light-4x.png": "cd8a8b898caee93527e4ec48148a1652",
"version.json": "704fe31c828f7d437bd8cbceb0179a05"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
