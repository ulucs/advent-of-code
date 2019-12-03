require AoCUtils

defmodule Day17 do
  def l({x, y}), do: {x - 1, y}
  def r({x, y}), do: {x + 1, y}
  def u({x, y}), do: {x, y - 1}
  def d({x, y}), do: {x, y + 1}

  def parse_in(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [c1, v, c2, rs, re] = String.split(line, ~r{[=,\s.]+}, trim: true)
      %{c1 => [String.to_integer(v)], c2 => String.to_integer(rs)..String.to_integer(re)}
    end)
    |> Enum.flat_map(fn %{"x" => xr, "y" => yr} ->
      Enum.flat_map(yr, fn y ->
        Enum.map(xr, fn x ->
          {x, y}
        end)
      end)
    end)
    |> MapSet.new()
  end

  def run_water(%{c: cs, w: rw, a: aw, l: ls, r: rs}) do
    Enum.reduce(aw, [], fn a ->
      cond do
        d(a) in rw || d(a) in cs ->
          nil
      end
    end)
  end

  def silver(input) do
    map = %{c: parse_in(input), a: MapSet.new([{1, 500}]), w: MapSet.new()}

    {_, yx} = Enum.max_by(map.c, &elem(&1, 1))
  end
end

"x=533, y=1429..1441
x=480, y=117..119
x=421, y=1751..1772
y=1785, x=456..458
y=956, x=570..593
x=507, y=473..475
x=422, y=1342..1355
x=515, y=529..553
y=1056, x=529..548
y=1168, x=519..539
x=498, y=370..392
x=532, y=859..879
x=559, y=1232..1235
y=142, x=470..478
x=454, y=587..590
y=170, x=563..588
x=566, y=1663..1669
x=423, y=1587..1612
x=473, y=1328..1337
x=479, y=1050..1052
x=562, y=280..292
y=1146, x=493..495
y=169, x=523..546
x=439, y=1370..1396
x=532, y=1669..1680
x=452, y=748..761
x=450, y=497..509
y=1792, x=440..464
x=584, y=1189..1212
y=1303, x=570..572
y=315, x=573..589
x=413, y=1039..1046
x=519, y=8..22
y=840, x=476..492
x=564, y=1508..1523
x=489, y=1074..1077
y=1462, x=469..561
x=464, y=1783..1792
x=466, y=110..123
x=460, y=824..828
x=481, y=1727..1732
x=513, y=274..301
x=555, y=1115..1136
y=1483, x=552..570
y=1002, x=533..555
x=495, y=1221..1233
x=436, y=541..550
x=560, y=1115..1136
x=437, y=1737..1745
x=551, y=416..441
x=445, y=1187..1203
y=1788, x=456..458
y=1192, x=508..524
x=433, y=420..431
x=480, y=1655..1660
y=349, x=419..424
x=532, y=1159..1164
y=379, x=473..484
y=800, x=496..519
x=523, y=930..942
x=528, y=808..820
y=814, x=498..501
x=445, y=1419..1437
x=464, y=133..145
y=141, x=519..522
x=531, y=1601..1619
x=516, y=302..314
y=1114, x=584..589
y=799, x=595..597
x=468, y=788..795
x=557, y=577..580
x=586, y=937..944
x=524, y=1183..1192
x=440, y=86..101
y=1235, x=559..579
y=878, x=476..478
x=479, y=682..694
x=591, y=973..991
y=189, x=454..473
x=561, y=617..641
y=1323, x=476..482
x=580, y=279..292
x=484, y=384..392
y=166, x=456..471
x=460, y=1470..1483
y=1467, x=584..592
x=578, y=254..268
x=569, y=1612..1614
x=503, y=1298..1309
x=566, y=1747..1754
x=548, y=1029..1056
x=515, y=627..644
x=479, y=561..565
y=235, x=499..515
x=431, y=518..529
y=1459, x=507..526
y=65, x=512..531
y=938, x=544..560
y=1491, x=513..538
x=489, y=1533..1546
x=413, y=1335..1360
x=424, y=1620..1643
y=1556, x=577..592
x=512, y=29..41
x=589, y=1097..1114
y=393, x=428..449
x=579, y=1133..1136
x=480, y=1470..1483
x=473, y=177..189
x=504, y=1143..1155
x=462, y=655..668
x=492, y=829..840
x=436, y=725..737
y=515, x=564..572
y=82, x=515..519
x=562, y=1647..1650
y=1212, x=580..584
y=1248, x=564..576
y=1330, x=579..597
y=1450, x=585..597
x=533, y=628..644
x=597, y=394..412
x=455, y=440..453
x=472, y=343..352
x=552, y=1109..1135
y=335, x=432..602
x=482, y=419..426
x=567, y=618..641
x=450, y=517..529
y=591, x=525..539
y=926, x=480..496
y=1058, x=456..494
x=565, y=1541..1552
x=586, y=419..433
x=513, y=1389..1399
y=780, x=507..525
x=567, y=1689..1698
x=427, y=623..651
x=485, y=871..882
x=469, y=401..410
x=482, y=1319..1323
x=505, y=1512..1523
x=554, y=1628..1633
y=301, x=486..513
x=470, y=807..833
x=488, y=752..757
y=190, x=529..548
x=541, y=605..607
x=523, y=988..1011
x=420, y=873..877
x=505, y=573..583
y=540, x=525..533
x=419, y=238..242
x=581, y=222..228
x=550, y=150..160
x=501, y=810..814
x=456, y=1785..1788
x=555, y=1291..1306
y=522, x=438..444
x=496, y=1516..1518
y=433, x=584..586
x=525, y=582..591
x=592, y=192..207
x=526, y=231..250
x=462, y=576..594
x=434, y=768..773
x=532, y=1687..1692
x=478, y=951..962
x=524, y=1686..1692
x=515, y=1046..1057
y=1556, x=525..553
y=876, x=543..555
x=452, y=910..927
y=163, x=462..464
x=450, y=1308..1322
x=496, y=1162..1172
x=524, y=1256..1266
x=458, y=1785..1788
y=761, x=452..507
y=494, x=492..514
x=489, y=1218..1230
x=435, y=1577..1595
x=432, y=685..705
x=493, y=328..332
x=413, y=342..352
x=450, y=303..308
y=34, x=504..506
y=1518, x=488..496
x=513, y=134..146
x=525, y=988..1011
x=433, y=1348..1350
x=457, y=361..379
y=459, x=588..595
x=437, y=1506..1515
x=522, y=505..520
x=547, y=1064..1087
x=563, y=704..720
x=441, y=499..508
x=583, y=937..944
x=476, y=1320..1323
x=534, y=174..185
y=1698, x=541..567
y=831, x=433..438
x=591, y=1617..1629
x=600, y=1080..1082
x=545, y=1331..1343
y=810, x=498..501
x=588, y=145..170
x=443, y=538..547
x=575, y=1041..1069
x=414, y=874..877
y=1052, x=471..479
x=469, y=1449..1462
y=352, x=466..472
x=502, y=918..925
y=1546, x=434..489
y=1332, x=495..518
y=1754, x=545..566
y=23, x=562..572
x=430, y=407..409
y=1050, x=471..479
x=544, y=897..903
y=250, x=497..499
y=1625, x=484..488
x=516, y=1733..1754
y=431, x=433..455
x=458, y=726..737
x=544, y=346..358
x=486, y=52..62
x=438, y=994..1010
x=450, y=637..650
y=1497, x=459..461
x=474, y=169..172
x=452, y=1653..1680
y=410, x=457..469
x=431, y=1634..1647
x=597, y=254..268
y=1422, x=598..600
y=999, x=547..549
x=476, y=1571..1580
y=1169, x=455..466
y=102, x=476..518
x=479, y=975..977
x=525, y=1545..1556
x=566, y=83..91
y=775, x=514..518
y=775, x=471..487
x=552, y=1490..1499
y=1549, x=583..585
x=545, y=1747..1754
y=786, x=438..443
x=500, y=595..608
x=520, y=1067..1081
x=499, y=228..235
y=1017, x=494..517
x=504, y=955..960
x=417, y=315..317
x=511, y=97..99
x=580, y=1417..1429
x=560, y=819..833
y=1286, x=493..535
x=564, y=1244..1248
x=584, y=1097..1114
y=1298, x=570..572
x=517, y=1627..1648
x=479, y=50..59
x=515, y=1239..1249
y=626, x=433..449
x=465, y=1066..1079
y=1166, x=436..445
x=472, y=752..757
x=476, y=497..509
x=446, y=538..547
x=458, y=1514..1519
x=573, y=186..206
x=561, y=1448..1462
y=1657, x=556..572
y=820, x=525..528
y=520, x=522..525
y=392, x=475..484
y=186, x=462..464
x=533, y=979..1002
y=1563, x=453..461
y=1745, x=422..437
x=523, y=156..169
y=1516, x=488..496
x=439, y=878..897
y=1175, x=482..502
x=542, y=15..28
x=506, y=1228..1234
x=529, y=445..469
x=494, y=704..715
y=1742, x=553..559
x=438, y=515..522
x=539, y=898..903
x=460, y=655..668
x=429, y=795..798
x=428, y=30..44
x=422, y=624..651
x=431, y=850..852
x=544, y=1155..1159
y=250, x=526..553
y=91, x=566..591
x=423, y=18..23
x=459, y=1607..1609
y=1468, x=428..446
x=536, y=1615..1640
y=1614, x=569..572
y=1590, x=531..545
x=525, y=769..780
x=459, y=1702..1716
x=471, y=153..166
x=466, y=1743..1753
y=1441, x=533..549
x=588, y=870..877
x=589, y=1743..1751
x=428, y=407..409
y=1771, x=464..470
x=508, y=1183..1192
x=472, y=1075..1081
y=1036, x=555..562
x=483, y=848..860
x=464, y=175..186
x=447, y=685..705
x=562, y=1030..1036
y=999, x=482..502
y=1265, x=549..551
x=444, y=170..189
y=1754, x=516..536
y=1014, x=506..511
x=489, y=969..980
x=496, y=1782..1787
y=568, x=442..491
y=1552, x=565..568
y=1089, x=564..568
y=1273, x=460..478
x=598, y=1618..1629
x=537, y=810..824
x=446, y=1461..1468
x=462, y=161..163
y=62, x=468..486
y=1026, x=569..583
x=531, y=135..146
x=548, y=1200..1205
y=1408, x=426..453
x=598, y=1407..1422
y=640, x=524..526
x=466, y=638..650
x=426, y=367..369
y=1783, x=535..548
y=1692, x=463..469
x=508, y=1636..1649
x=570, y=933..956
y=100, x=579..583
y=1350, x=521..525
x=471, y=731..736
y=1010, x=533..546
x=453, y=1556..1563
x=425, y=1210..1234
x=555, y=185..206
x=427, y=563..572
x=497, y=1303..1306
y=268, x=431..578
x=504, y=34..37
x=523, y=1302..1306
x=476, y=830..840
y=1680, x=522..532
x=435, y=1606..1609
x=541, y=1688..1698
y=604, x=571..595
x=501, y=1203..1213
x=568, y=1319..1332
x=504, y=374..381
x=496, y=1363..1377
y=1026, x=447..454
x=536, y=1734..1754
x=586, y=255..268
x=588, y=393..412
y=550, x=436..452
x=564, y=448..461
x=521, y=1346..1350
x=507, y=1602..1619
y=172, x=474..476
y=292, x=562..580
y=1775, x=454..479
y=1690, x=502..504
x=452, y=878..882
x=498, y=529..553
x=525, y=1346..1350
x=478, y=1617..1628
x=502, y=150..175
y=73, x=563..575
x=425, y=769..773
x=546, y=664..685
x=545, y=887..892
x=555, y=979..1002
x=428, y=81..103
x=435, y=1348..1350
y=819, x=485..507
x=592, y=1230..1239
y=608, x=476..500
x=417, y=277..290
x=561, y=1691..1695
y=1586, x=466..483
y=1629, x=591..598
y=1607, x=475..492
y=630, x=466..510
x=455, y=420..431
x=554, y=379..383
x=519, y=790..800
y=921, x=551..560
x=424, y=340..349
x=594, y=473..479
x=575, y=532..541
x=448, y=911..927
x=477, y=800..802
x=519, y=1208..1215
y=659, x=534..561
x=520, y=1560..1583
y=123, x=466..529
x=544, y=389..401
y=1609, x=518..525
x=416, y=564..572
x=597, y=1322..1330
y=1693, x=490..510
y=1361, x=583..596
y=1515, x=419..437
x=489, y=1782..1787
y=1660, x=480..486
y=1437, x=438..445
y=1057, x=515..518
y=1750, x=475..478
x=543, y=703..720
x=451, y=459..470
x=583, y=1048..1064
y=1081, x=502..520
x=535, y=43..58
x=421, y=363..373
y=1203, x=420..445
x=535, y=1276..1286
x=525, y=1221..1229
y=1262, x=436..446
x=524, y=1048..1060
y=946, x=538..566
x=492, y=436..446
y=1389, x=550..555
y=11, x=543..569
x=475, y=1594..1607
x=518, y=1046..1057
y=1580, x=474..476
y=439, x=559..565
y=228, x=581..583
x=598, y=845..864
x=428, y=1462..1468
x=588, y=444..459
y=164, x=530..534
y=853, x=473..475
y=1234, x=506..518
x=543, y=1426..1437
x=542, y=502..527
x=436, y=1257..1262
x=470, y=361..379
x=426, y=1672..1675
y=58, x=535..541
x=579, y=1627..1635
x=581, y=717..729
x=540, y=1426..1437
x=584, y=898..926
x=478, y=1203..1213
x=502, y=1688..1690
x=444, y=1703..1716
x=540, y=773..790
y=85, x=510..530
x=481, y=1407..1418
y=1612, x=419..423
x=561, y=606..607
x=446, y=1257..1262
y=525, x=579..589
y=239, x=449..455
y=1082, x=591..600
x=548, y=1628..1633
x=538, y=1385..1397
x=501, y=435..446
y=852, x=431..456
x=571, y=592..604
x=555, y=1029..1036
y=1020, x=554..562
y=451, x=418..439
y=449, x=460..467
x=579, y=98..100
y=1648, x=517..520
x=450, y=704..715
x=444, y=515..522
y=308, x=450..457
x=504, y=1664..1666
y=1074, x=448..455
y=1671, x=498..518
x=487, y=1218..1230
y=1732, x=477..481
x=555, y=1387..1389
x=418, y=1052..1061
x=432, y=324..335
y=59, x=476..479
x=433, y=170..189
x=573, y=301..315
x=445, y=475..487
x=494, y=1046..1058
y=1412, x=488..503
y=734, x=480..496
x=569, y=8..11
x=561, y=587..592
x=551, y=1244..1265
y=715, x=450..494
x=424, y=198..204
x=439, y=438..451
x=581, y=1118..1120
x=463, y=1285..1298
y=1538, x=441..453
y=903, x=539..544
y=1097, x=433..440
x=507, y=1065..1073
x=433, y=1088..1097
y=446, x=492..501
y=1322, x=450..466
x=475, y=850..853
x=583, y=221..228
x=460, y=1635..1649
x=505, y=1256..1266
x=560, y=764..776
y=1060, x=504..524
y=879, x=532..538
x=478, y=131..142
x=482, y=1164..1175
y=1071, x=448..455
x=577, y=1353..1360
y=22, x=499..519
y=1716, x=444..459
y=1152, x=493..495
x=543, y=8..11
y=1189, x=477..481
x=506, y=1010..1014
x=568, y=1063..1089
x=559, y=301..314
x=484, y=1744..1753
y=882, x=469..485
x=420, y=18..23
y=527, x=542..549
x=493, y=1303..1306
x=525, y=535..540
x=590, y=1412..1439
x=584, y=419..433
x=525, y=504..520
x=529, y=110..123
x=518, y=766..775
x=478, y=659..669
y=1617, x=561..584
x=583, y=1417..1429
x=493, y=1146..1152
x=525, y=50..62
y=1079, x=443..465
x=569, y=999..1026
x=519, y=71..82
x=564, y=1064..1089
x=449, y=615..626
x=527, y=954..960
x=468, y=53..62
x=596, y=1760..1765
x=519, y=1153..1168
x=594, y=1230..1239
x=487, y=1074..1077
y=1039, x=472..476
y=1229, x=525..528
x=585, y=1445..1450
x=473, y=356..379
x=454, y=178..189
x=546, y=1363..1377
x=552, y=77..92
y=1360, x=413..418
y=552, x=555..580
x=470, y=1769..1771
x=462, y=1403..1406
y=117, x=545..562
x=464, y=161..163
y=185, x=534..540
y=1778, x=517..526
x=592, y=1455..1467
y=1683, x=580..593
x=525, y=1609..1614
x=490, y=722..731
x=579, y=1323..1330
x=529, y=1159..1164
x=541, y=955..966
y=1135, x=540..552
x=602, y=323..335
x=526, y=698..724
x=418, y=82..103
x=560, y=938..942
y=720, x=543..563
x=512, y=6..19
y=1649, x=460..508
x=564, y=500..515
x=510, y=1125..1136
x=520, y=1367..1370
x=595, y=592..604
y=383, x=548..554
y=1306, x=493..497
x=554, y=1011..1020
y=1501, x=459..461
x=573, y=1412..1439
x=435, y=1053..1061
x=440, y=1089..1097
y=1619, x=507..531
x=543, y=1332..1343
x=530, y=74..85
x=460, y=1265..1273
x=550, y=14..28
x=549, y=1244..1265
x=476, y=1220..1233
y=1753, x=466..484
y=206, x=513..532
y=580, x=543..557
y=1406, x=462..470
x=532, y=196..206
x=595, y=899..926
x=598, y=1047..1064
x=579, y=497..525
x=560, y=82..88
x=481, y=975..977
y=207, x=592..600
y=1073, x=507..513
y=1707, x=572..586
x=441, y=1635..1647
x=586, y=1695..1707
y=1061, x=418..435
x=546, y=156..169
x=515, y=71..82
x=507, y=768..780
y=917, x=435..445
x=502, y=1165..1175
y=1087, x=530..547
x=466, y=617..630
y=553, x=498..515
x=555, y=550..552
y=1499, x=552..563
y=644, x=456..459
x=593, y=1656..1683
x=484, y=134..145
x=560, y=899..921
y=99, x=488..511
x=531, y=1343..1353
y=103, x=418..428
y=962, x=453..478
x=540, y=174..185
y=453, x=455..473
x=433, y=819..831
y=206, x=555..573
x=449, y=383..393
x=436, y=1142..1166
x=463, y=86..101
x=473, y=439..453
x=484, y=1144..1155
x=487, y=771..775
x=446, y=114..126
y=379, x=457..470
x=434, y=1441..1443
y=714, x=553..555
x=461, y=232..245
y=877, x=567..588
y=26, x=431..445
x=493, y=1126..1136
y=1136, x=555..560
x=495, y=1318..1332
x=547, y=996..999
y=1772, x=421..430
x=589, y=497..525
y=1504, x=446..495
y=802, x=477..489
y=28, x=542..550
x=460, y=437..449
x=417, y=1621..1643
y=897, x=437..439
x=444, y=278..290
y=529, x=431..450
x=490, y=601..603
y=166, x=530..534
y=509, x=450..476
x=518, y=444..469
x=567, y=1353..1360
x=504, y=1559..1583
y=1496, x=415..442
x=457, y=1688..1699
x=553, y=1724..1742
x=419, y=1506..1515
y=1595, x=435..446
x=546, y=1005..1010
y=1230, x=487..489
x=435, y=367..369
y=572, x=416..427
y=1046, x=413..427
x=446, y=211..222
y=960, x=504..527
y=685, x=546..562
x=470, y=131..142
x=563, y=1628..1635
x=518, y=1319..1332
x=431, y=254..268
y=1164, x=529..532
x=474, y=1571..1580
x=475, y=467..472
y=1633, x=548..554
x=513, y=1065..1073
y=1745, x=575..577
x=559, y=1691..1695
x=483, y=1574..1586
y=1418, x=481..547
y=62, x=523..525
x=466, y=342..352
x=548, y=176..190
x=435, y=1103..1114
y=877, x=414..420
x=533, y=535..540
x=488, y=182..204
y=700, x=584..586
x=528, y=1221..1229
y=1298, x=446..463
x=465, y=1425..1427
x=441, y=1342..1355
x=555, y=863..876
y=317, x=415..417
x=466, y=931..942
x=483, y=1554..1565
x=591, y=82..91
y=795, x=460..468
y=1666, x=504..512
x=422, y=1738..1745
y=1699, x=438..457
x=583, y=1544..1549
y=634, x=538..542
y=978, x=429..450
y=925, x=502..509
y=487, x=561..569
y=1350, x=433..435
x=438, y=820..831
x=533, y=1200..1205
y=1159, x=529..532
x=555, y=676..678
y=146, x=513..531
x=455, y=229..239
x=549, y=996..999
x=440, y=1274..1296
x=589, y=302..315
y=1787, x=489..496
y=1427, x=450..465
x=522, y=1367..1370
y=586, x=491..511
x=468, y=658..671
x=511, y=1343..1353
x=527, y=890..901
x=596, y=1718..1723
x=577, y=1529..1556
y=729, x=581..597
x=417, y=238..242
y=1455, x=507..526
x=471, y=770..775
x=450, y=951..978
x=495, y=1146..1152
y=1172, x=494..496
x=553, y=676..678
y=594, x=445..462
y=644, x=515..533
x=440, y=401..413
x=477, y=1727..1732
y=289, x=568..573
x=453, y=1402..1408
x=559, y=411..439
x=569, y=803..810
x=445, y=14..26
x=418, y=438..451
x=555, y=712..714
x=503, y=573..583
y=980, x=469..489
x=556, y=479..490
x=553, y=149..160
x=480, y=907..926
y=1377, x=496..546
y=1011, x=523..525
y=1098, x=455..473
y=724, x=513..526
x=423, y=475..483
y=694, x=462..479
y=1483, x=460..480
x=415, y=316..317
x=570, y=1298..1303
y=1643, x=417..424
x=538, y=859..879
y=1443, x=434..462
x=491, y=576..586
x=572, y=1695..1707
y=41, x=486..512
x=476, y=890..901
x=436, y=995..1010
y=882, x=442..452
x=522, y=1207..1215
x=593, y=1743..1751
x=530, y=1065..1087
x=565, y=1117..1120
x=565, y=369..373
x=529, y=1028..1056
x=498, y=810..814
x=427, y=153..167
y=470, x=433..451
y=469, x=518..529
x=512, y=1664..1666
x=568, y=1540..1552
x=457, y=1653..1680
y=475, x=507..534
x=584, y=674..700
x=554, y=390..406
x=576, y=1319..1332
y=1086, x=419..428
x=462, y=1441..1443
x=583, y=1349..1361
x=478, y=1264..1273
x=502, y=1104..1114
y=32, x=455..468
x=531, y=1566..1590
x=419, y=1586..1612
x=585, y=328..332
x=585, y=802..810
y=1614, x=518..525
x=449, y=275..285
y=773, x=425..434
x=473, y=850..853
x=539, y=581..591
x=502, y=1068..1081
y=681, x=414..436
y=1337, x=446..473
x=562, y=1010..1020
x=548, y=1762..1783
y=1675, x=415..426
y=603, x=490..493
y=1429, x=580..583
x=476, y=92..102
y=1370, x=520..522
y=991, x=576..591
x=428, y=383..393
y=1735, x=468..489
x=510, y=73..85
x=572, y=1644..1657
x=453, y=1535..1538
y=1205, x=533..548
x=430, y=1751..1772
x=444, y=231..245
x=470, y=1404..1406
x=522, y=1668..1680
y=864, x=580..598
y=1239, x=592..594
x=469, y=1182..1194
y=860, x=463..483
x=533, y=1006..1010
x=577, y=1132..1136
x=493, y=1277..1286
y=977, x=479..481
x=561, y=1384..1397
x=600, y=1406..1422
y=1309, x=478..503
x=510, y=851..861
x=427, y=1039..1046
x=566, y=1156..1159
y=757, x=472..488
y=392, x=498..514
x=514, y=766..775
x=492, y=1594..1607
x=419, y=340..349
x=510, y=616..630
x=572, y=501..515
y=833, x=449..470
x=448, y=1071..1074
x=497, y=245..250
x=597, y=26..44
x=425, y=475..483
y=1523, x=483..505
x=489, y=1182..1194
x=561, y=484..487
x=432, y=343..352
x=480, y=1074..1081
x=567, y=869..877
x=433, y=477..487
x=499, y=1553..1565
x=445, y=577..594
x=539, y=1152..1168
y=1234, x=425..439
x=591, y=1079..1082
x=456, y=987..990
x=580, y=764..776
x=540, y=1663..1669
x=496, y=724..734
x=454, y=1020..1026
y=1395, x=429..432
x=584, y=1455..1467
x=488, y=420..426
y=798, x=415..429
x=415, y=1490..1496
y=607, x=541..561
x=413, y=1308..1311
y=810, x=569..585
x=457, y=304..308
y=927, x=448..452
x=565, y=1271..1280
x=518, y=1388..1399
y=1288, x=453..455
x=566, y=929..946
x=456, y=1046..1058
y=942, x=544..560
y=1519, x=458..465
x=485, y=808..819
y=353, x=550..559
x=421, y=1275..1296
x=526, y=1763..1778
y=1417, x=580..583
x=469, y=870..882
x=568, y=277..289
y=1628, x=478..494
x=563, y=69..73
y=1404, x=576..580
y=175, x=502..509
x=578, y=1507..1523
x=414, y=680..681
x=552, y=1480..1483
x=504, y=1049..1060
x=580, y=845..864
x=445, y=1142..1166
y=1343, x=543..545
y=1680, x=452..457
x=460, y=789..795
x=438, y=1419..1437
y=966, x=541..554
x=562, y=447..461
y=472, x=475..494
x=457, y=400..410
x=568, y=819..833
y=401, x=533..544
x=431, y=14..26
x=446, y=1285..1298
y=358, x=544..565
y=937, x=583..586
y=926, x=584..595
x=488, y=1516..1518
x=456, y=115..126
y=1266, x=505..524
x=442, y=558..568
y=92, x=547..552
x=478, y=1379..1403
x=443, y=761..786
x=465, y=1515..1519
x=454, y=1765..1775
y=204, x=488..509
y=1399, x=513..518
x=499, y=9..22
y=731, x=488..490
x=513, y=195..206
x=479, y=1764..1775
x=436, y=679..681
x=439, y=1209..1234
x=525, y=808..820
y=1476, x=568..581
x=494, y=1162..1172
y=1081, x=472..480
y=332, x=493..585
y=1716, x=479..498
x=456, y=849..852
x=528, y=1302..1306
x=535, y=1761..1783
y=1583, x=504..520
x=542, y=616..634
x=526, y=1455..1459
x=492, y=490..494
x=486, y=273..301
x=577, y=1724..1745
x=499, y=1740..1755
y=583, x=503..505
y=1692, x=524..532
x=475, y=384..392
x=561, y=653..659
x=494, y=1616..1628
x=474, y=561..565
x=580, y=1378..1404
x=547, y=78..92
x=549, y=502..527
x=524, y=638..640
y=1360, x=567..577
y=242, x=417..419
y=1355, x=422..441
x=507, y=374..381
x=513, y=1479..1491
y=892, x=545..562
x=540, y=1108..1135
x=572, y=21..23
x=453, y=950..962
x=576, y=1243..1248
x=456, y=154..166
x=548, y=533..541
y=1403, x=478..481
x=489, y=800..802
x=463, y=847..860
y=483, x=423..425
y=441, x=539..551
y=44, x=425..428
x=509, y=919..925
y=1069, x=573..575
y=1311, x=413..429
x=575, y=1725..1745
x=489, y=1723..1735
x=556, y=1645..1657
x=488, y=97..99
y=245, x=444..461
x=455, y=1288..1292
y=1306, x=523..528
x=445, y=910..917
x=462, y=476..487
x=538, y=302..314
x=486, y=1654..1660
x=477, y=1189..1191
y=1751, x=589..593
x=469, y=1670..1692
x=541, y=908..921
x=538, y=1480..1491
x=558, y=81..88
x=469, y=969..980
y=373, x=421..441
x=513, y=697..724
y=1155, x=484..504
x=538, y=617..634
x=533, y=388..401
x=559, y=351..353
x=464, y=1769..1771
x=541, y=43..58
x=420, y=1187..1203
x=521, y=302..314
x=531, y=53..65
x=506, y=34..37
x=471, y=1050..1052
x=490, y=1680..1693
x=494, y=466..472
y=861, x=510..513
x=526, y=638..640
x=565, y=347..358
y=650, x=450..466
y=592, x=548..561
y=369, x=426..435
x=515, y=228..235
x=496, y=906..926
y=1077, x=487..489
y=678, x=553..555
x=452, y=540..550
y=126, x=446..456
x=518, y=1227..1234
x=530, y=164..166
x=463, y=824..828
x=465, y=1016..1033
x=534, y=473..475
x=595, y=445..459
y=314, x=538..559
x=507, y=807..819
x=573, y=277..289
x=498, y=1702..1716
x=597, y=777..799
x=562, y=665..685
x=519, y=132..141
y=1280, x=565..593
x=510, y=1679..1693
x=563, y=1490..1499
x=476, y=868..878
y=790, x=528..540
x=429, y=951..978
y=1136, x=493..510
x=438, y=760..786
x=545, y=1566..1590
x=493, y=601..603
y=1397, x=538..561
x=459, y=635..644
x=579, y=478..490
x=572, y=1612..1614
y=1213, x=478..501
x=550, y=351..353
x=597, y=1446..1450
y=101, x=440..463
x=516, y=909..921
y=484, x=561..569
y=479, x=592..594
y=1650, x=562..564
y=426, x=482..488
x=579, y=1231..1235
y=37, x=504..506
x=438, y=1017..1033
y=119, x=480..482
x=577, y=1759..1765
x=415, y=795..798
x=486, y=29..41
x=563, y=211..222
x=576, y=1377..1404
y=487, x=445..462
x=553, y=230..250
y=590, x=451..454
x=519, y=811..824
x=580, y=1188..1212
x=593, y=1271..1280
x=517, y=1763..1778
x=479, y=1703..1716
x=580, y=550..552
y=160, x=550..553
x=435, y=910..917
y=23, x=420..423
x=452, y=276..285
x=511, y=575..586
y=1136, x=577..579
x=592, y=472..479
x=562, y=116..117
y=1306, x=555..583
x=534, y=164..166
x=449, y=229..239
y=88, x=558..560
y=1553, x=534..544
x=449, y=657..671
x=503, y=1410..1412
x=484, y=1027..1041
x=502, y=658..669
x=432, y=1374..1395
y=1635, x=563..579
y=1159, x=544..566
y=736, x=467..471
x=562, y=886..892
x=581, y=1463..1476
x=466, y=1307..1322
y=1191, x=477..481
x=463, y=1669..1692
y=651, x=422..427
y=1010, x=436..438
x=575, y=68..73
x=419, y=1075..1086
y=1535, x=441..453
x=586, y=1718..1723
x=476, y=1015..1039
y=944, x=583..586
x=467, y=437..449
y=19, x=510..512
x=476, y=169..172
x=467, y=731..736
x=543, y=863..876
x=507, y=749..761
x=570, y=1479..1483
x=491, y=559..568
x=583, y=998..1026
x=443, y=199..204
x=547, y=1407..1418
x=573, y=1042..1069
y=1033, x=438..465
y=1437, x=540..543
x=517, y=1006..1017
x=510, y=6..19
y=1114, x=435..502
x=494, y=1007..1017
x=440, y=1782..1792
x=508, y=1740..1755
x=512, y=52..65
x=534, y=1550..1553
y=1064, x=583..598
x=451, y=587..590
x=518, y=1658..1671
x=441, y=364..373
y=373, x=565..569
y=352, x=413..432
x=455, y=1143..1169
x=476, y=50..59
x=553, y=712..714
x=523, y=50..62
y=409, x=428..430
y=547, x=443..446
x=504, y=1028..1041
y=1292, x=453..455
y=167, x=417..427
x=584, y=1594..1617
x=478, y=1297..1309
x=449, y=806..833
y=1609, x=435..459
y=1120, x=565..581
y=1565, x=483..499
y=1647, x=431..441
y=1215, x=519..522
x=446, y=1494..1504
y=1303, x=493..497
x=455, y=1071..1074
y=204, x=424..443
x=548, y=586..592
y=1669, x=540..566
x=534, y=654..659
x=466, y=1573..1586
x=568, y=1463..1476
x=511, y=1010..1014
x=468, y=1724..1735
x=597, y=718..729
x=599, y=25..44
x=415, y=1672..1675
x=437, y=878..897
x=514, y=369..392
x=461, y=1555..1563
x=520, y=1627..1648
x=418, y=1335..1360
x=583, y=98..100
x=522, y=132..141
y=222, x=446..563
x=562, y=21..23
x=496, y=790..800
y=145, x=464..484
y=508, x=420..441
x=551, y=900..921
y=1233, x=476..495
x=572, y=1298..1303
y=561, x=474..479
x=434, y=1532..1546
x=592, y=1530..1556
y=1695, x=559..561
x=430, y=987..990
x=545, y=115..117
y=1523, x=564..578
y=901, x=476..527
x=514, y=490..494
x=482, y=117..119
x=462, y=175..186
x=554, y=954..966
y=942, x=466..523
x=420, y=498..508
x=553, y=1545..1556
x=528, y=774..790
x=509, y=151..175
x=600, y=192..207
x=481, y=1189..1191
x=569, y=370..373
y=921, x=516..541
x=450, y=1424..1427
y=1723, x=586..596
y=1194, x=469..489
x=462, y=682..694
y=490, x=556..579
x=488, y=1410..1412
x=429, y=1309..1311
x=498, y=1659..1671
x=561, y=1595..1617
x=446, y=1578..1595
x=433, y=616..626
y=776, x=560..580
x=529, y=177..190
x=580, y=1656..1683
x=454, y=1238..1249
y=705, x=432..447
y=833, x=560..568
x=478, y=1741..1750
x=548, y=379..383
x=569, y=484..487
y=737, x=436..458
x=426, y=1403..1408
x=466, y=1143..1169
x=459, y=1369..1396
x=507, y=1455..1459
x=429, y=1374..1395
x=476, y=595..608
x=447, y=1020..1026
x=495, y=1494..1504
x=549, y=1428..1441
x=455, y=1087..1098
x=441, y=1535..1538
y=44, x=597..599
y=1439, x=573..590
y=413, x=414..440
x=442, y=1490..1496
x=428, y=1076..1086
y=1332, x=568..576
x=473, y=1086..1098
x=565, y=411..439
x=459, y=1497..1501
x=455, y=27..32
x=583, y=1291..1306
y=541, x=548..575
x=586, y=674..700
x=585, y=1544..1549
y=1249, x=454..515
x=544, y=938..942
y=1688, x=502..504
y=381, x=504..507
y=990, x=430..456
x=544, y=1550..1553
x=518, y=92..102
x=456, y=635..644
y=406, x=554..579
y=638, x=524..526
y=1396, x=439..459
y=290, x=417..444
x=480, y=725..734
x=564, y=1647..1650
y=412, x=588..597
x=484, y=1614..1625
y=1640, x=536..543
x=539, y=417..441
x=482, y=989..999
x=502, y=989..999
x=563, y=145..170
y=669, x=478..502
x=595, y=776..799
x=461, y=1497..1501
y=1353, x=511..531
x=468, y=26..32
x=472, y=1015..1039
y=828, x=460..463
y=1755, x=499..508
x=518, y=1609..1614
x=543, y=578..580
x=438, y=1689..1699
y=487, x=415..433
x=475, y=1741..1750
y=641, x=561..567
y=668, x=460..462
x=543, y=1614..1640
y=824, x=519..537
x=513, y=850..861
x=504, y=1688..1690
x=499, y=246..250
x=579, y=390..406
x=538, y=929..946
x=446, y=1328..1337
x=478, y=868..878
x=509, y=181..204
x=559, y=1724..1742
x=442, y=877..882
y=1296, x=421..440
x=443, y=1066..1079
x=425, y=29..44
y=268, x=586..597
y=461, x=562..564
x=481, y=1380..1403
y=565, x=474..479
x=488, y=1614..1625
y=314, x=516..521
x=453, y=1288..1292
x=483, y=1513..1523
y=189, x=433..444
x=596, y=1350..1361
x=550, y=1387..1389
x=576, y=973..991
y=285, x=449..452
y=1041, x=484..504
x=414, y=400..413
x=417, y=152..167
y=1664, x=504..512
y=374, x=504..507
x=484, y=357..379
y=671, x=449..468
y=1765, x=577..596
x=488, y=722..731
x=433, y=460..470
x=593, y=934..956
x=415, y=478..487" |> Day17.silver() |> IO.puts()
