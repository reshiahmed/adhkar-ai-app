// AdhkarData.swift — Static seed data matching the PWA content

import Foundation

struct AdhkarData {

    // MARK: - Morning Adhkar (14 entries, matching PWA order)
    static var morning: [Dhikr] = [
        Dhikr(
            id: "m0",
            arabic: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهو الْعَلِيُّ الْعَظِيمُ",
            transliteration: "Allahu la ilaha illa huwal hayyul qayyum, la ta'khudhuhu sinatun wala nawm, lahu ma fis-samawati wama fil-ard, man dhal-ladhi yashfa'u 'indahu illa bi-idhnih, ya'lamu ma bayna aydihim wama khalfahum, wala yuhituna bishay'in min 'ilmihi illa bima sha', wasi'a kursiyyuhus-samawati wal-arda wala ya'uduhu hifdhuhuma, wa huwal 'aliyyul 'adheem",
            translation: "Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
            repetitions: 1,
            source: "Quran 2:255",
            category: .morning,
            benefit: "Nothing prevents entry to Paradise except death for whoever recites this after each fard prayer."
        ),
        Dhikr(
            id: "m1",
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            transliteration: "Allahumma anta rabbee La ilaha illa ant, khalaqtanee wa ana 'abduk, wa ana 'ala 'ahdika wa w'adika masta-ta'tu, a'uthubika min sharri ma sana'tu, abu-u laka bi ni'matika 'alayya, wa abu-u bi-dhambi, faghfirlee finnahu laa yaghfirudh-dhunooba illa ant",
            translation: "O Allah! You are my Lord; none has the right to be worshipped but You. You created me and I am Your slave and I am faithful to my covenant, and my commitment to You as far as I am able. I seek Your refuge from the evil of what I have done. I acknowledge before You all of the favours that You have bestowed upon me and I confess to you all my sins. Forgive me, for there is none who can forgive sins except You.",
            repetitions: 1,
            source: "Bukhari 6306",
            category: .morning,
            benefit: "Sayyidul Istighfaar: Whoever recites it during the day with firm conviction and dies before evening will be from the people of Paradise."
        ),
        Dhikr(
            id: "m2",
            arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "La ilaha illal-laahu wahdahu laa shareeka lahu, lahul mulku wa-lahul hamdu wa-huwa 'ala kulli shayin qadeer",
            translation: "None has the right to be worshipped but Allah alone Who has no partner. Sovereignty is His and all praise is for Him, and He has full power over all things.",
            repetitions: 10,
            source: "Bukhari 3293 & Muslim 2691",
            category: .morning,
            benefit: "Reward of freeing ten slaves, 100 good deeds, 100 sins erased, and protection from Shaytan till evening (if recited 100 times, or 10 times for a specific reward)."
        ),
        Dhikr(
            id: "m3",
            arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            transliteration: "Subhaanallaahi wa bi hamdihi",
            translation: "Glory is to Allah and Praise is to Him",
            repetitions: 100,
            source: "Bukhari 6405 & Muslim 2691",
            category: .morning,
            benefit: "All sins will be forgiven even if they were as much as the foam of the sea."
        ),
        Dhikr(
            id: "m4",
            arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Bismillaahil-ladhi laa yadduru ma'a ismihi shayun fil-ardi walaa fis-samaai wa-huwas samee'ul 'aleem",
            translation: "In the Name of Allah, Who with His Name nothing can cause harm in the Earth nor in the Heavens, and He is the All-Hearing, the All-Knowing.",
            repetitions: 3,
            source: "Ahmad 446 & Tirmidhi 3388",
            category: .morning,
            benefit: "Nothing shall come to harm him on that day and evening."
        ),
        Dhikr(
            id: "m5",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ، وَأَهْلِي وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي",
            transliteration: "Allahumma inni asalukal aafiyata fid-dunya wal aakhirah, Allahumma inni asalukal 'afwa wal 'aafiyata fee deenee wa dunyaay, wa ahlee wa maalee, Allahumas tur 'awratee, wa-aamin raw'aatee, Allahumahfathnee min bayni yaday, wa-min khalfee, wa-'an yameenee, wa-'an shimaalee, wa-min fawqee, wa a'udhu bi-'adhamatika an ughtaala min tahtee",
            translation: "O Allah, I seek Your protection in this world and the next. O Allah, I seek Your forgiveness and Your protection in my religion, in my worldly affairs, in my family and in my wealth. O Allah, conceal my faults and safeguard me from the things which I fear. O Allah, guard me from what is in front of me and behind me, and from my right, and from my left, and from above me, and I seek refuge in Your Greatness from being struck down from beneath me.",
            repetitions: 1,
            source: "Abu Dawud 5074",
            category: .morning,
            benefit: "The Prophet would always recite this whenever he entered upon the morning and evening."
        ),
        Dhikr(
            id: "m6",
            arabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ قُلْ هُوَ اللَّهُ أَحَدٌ (١) اللَّهُ الصَّمَدُ (٢) لَمْ يَلِدْ وَلَمْ يُولَدْ (٣) وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ (٤)",
            transliteration: "Bismillaah-hirahmaan-nirraheem. Qul huwal-laahu Ahad. Allaahus samad. Lam yalid wa lam yuwlad. Wa lam yakullahu kuf-fuw-wan Ahad",
            translation: "In the name of Allah, the Most Compassionate, Most Merciful. Say, He is Allah, One and Indivisible. Allah, the Sustainer needed by all. He has never had offspring, nor was He born. And there is none comparable to Him.",
            repetitions: 3,
            source: "Al-Ikhlas",
            category: .morning,
            benefit: "Reciting three times suffices as a protection against everything."
        ),
        Dhikr(
            id: "m7",
            arabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ (١) مِن شَرِّ مَا خَلَقَ (٢) وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ (٣) وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ (٤) وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ (٥)",
            transliteration: "Bismillaah-hirahmaan-nirraheem. Qul 'audhu birabbil falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idha waqab. Wa min sharrin naffa-thaati fil 'uqad. Wa min sharri haasidin idha hasad",
            translation: "In the name of Allah, the Most Compassionate, Most Merciful. Say, I seek refuge in the Lord of the daybreak. From the evil of whatever He has created. And from the evil of the night when it grows dark. And from the evil of those witches casting spells by blowing onto knots. And from the evil of an envier when they envy.",
            repetitions: 3,
            source: "Al-Falaq",
            category: .morning,
            benefit: "Reciting three times suffices as a protection against everything."
        ),
        Dhikr(
            id: "m8",
            arabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ النَّاسِ (١) مَلِكِ النَّاسِ (٢) إِلَهِ النَّاسِ (٣) مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ (٤) الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ (٥) مِنَ الْجِنَّةِ وَالنَّاسِ (٦)",
            transliteration: "Bismillaah-hirahmaan-nirraheem. Qul 'audhu birabbin naas. Malikin-naas. Ilaahin-naas. Min sharril waswaasil khannaas. El-ledhi yuwas-wisu fee sudoorin-naas. Minal jin-nati wan-naas",
            translation: "In the name of Allah, the Most Compassionate, Most Merciful. Say, I seek refuge in the Lord of humankind. The Master of humankind. The God of humankind. From the evil of the lurking whisper. Who whispers into the hearts of humankind. From among jinn and humankind.",
            repetitions: 3,
            source: "An-Nas",
            category: .morning,
            benefit: "Reciting three times suffices as a protection against everything."
        ),
        Dhikr(
            id: "m9",
            arabic: "رَضِيتُ بِاللَّهِ رَبَّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
            transliteration: "Radeetu billaahi rabban, wa-bil islaami deenan, wa-bi muhammadin sallal-laahu 'alayhi wa sallama nabeeyyan",
            translation: "I am pleased with Allah as my Lord, and with Islam as my Religion, and with Muhammad (Peace and Blessings of Allah be Upon Him) as my Prophet.",
            repetitions: 3,
            source: "Ahmad 18968",
            category: .morning,
            benefit: "Allah has made it binding upon Himself to please him on the Day of Resurrection."
        ),
        Dhikr(
            id: "m10",
            arabic: "اللَّهُمَّ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي وَشَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ",
            transliteration: "Allahumma faatiras samaa-waati wal ard, 'aalimal ghaybi washa-haadah, rabba kulli shayin wa maleekah, ash-hadu allaa-ilaaha illa ant, a'udhu bika min sharri nafsee, wa sharrish shaytaani wa shirkih, wa-an aktarifa 'alaa nafsee sooan, aw ajjuruhu ila muslim",
            translation: "O Allah, Creator of the Heavens and the Earth, Knower of the unseen and evident. Lord of all things and its Possessor. I testify that there is no God worthy of worship except You. I seek refuge in You from the evil of my soul and from the evil of Satan and his helpers. (I seek refuge in You) from bringing evil (sins) upon my soul and from harming any Muslim.",
            repetitions: 1,
            source: "Abu Dawud 5067",
            category: .morning,
            benefit: "The Prophet taught this Dua to Abu Bakr to say every morning and evening."
        ),
        Dhikr(
            id: "m11",
            arabic: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
            transliteration: "Yaa hayuu yaa qayyoom, bi-rahmatika astagheeth, uslihlee sha-nee kullahu wa-laa takil-nee ila nafsee tarfata 'ayn",
            translation: "O Ever Living One, O All-Sustaining One, by Your mercy I call on You to set right all of my affairs. Do not place me in charge of my soul even for the blinking of an eye.",
            repetitions: 1,
            source: "Nasa'i 10405",
            category: .morning,
            benefit: "The Prophet taught this Du'a to his daughter Fatima to say every morning and evening."
        ),
        Dhikr(
            id: "m12",
            arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ، وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ، وَشَرِّ مَا بَعْدَهُ، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ، وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ",
            transliteration: "Asbahnaa wa-asbahal mulku lillah, wal hamdu lillah, laa ilaaha ilal-laahu wahdahoo laa shareeka lah, lahul mulku, wa-lahul hamdu wa-huwa 'ala kulli shayin qadeer, rabbi as-aluka khayra maa fee hadhal yawm, wa khayra ma b'adah, wa 'audhu bika min sharri maa fee hadhal yawm, wa sharri maa b'adah, rabbi 'audhu bika minal kasal, wa-sooil kibar, rabbi 'audu bika min 'adhaabin fin-naari wa 'adhaabin fil qabr",
            translation: "We have entered a new day and the dominion belongs to Allah; Praise be to Allah; None has the right to be worshipped but Allah alone, Who has no partner. To Allah belongs the dominion, and to Him belongs all praise, and He is Able to do all things. My Lord, I ask You for the goodness of this day and that what comes after it, and I seek refuge in You from the evil of this day and that what comes after it. My Lord, I seek refuge in You from laziness and from the feebleness of old age. My Lord, I seek refuge in You from the punishment of the Hellfire, and from the punishment of the grave.",
            repetitions: 1,
            source: "Muslim 2723",
            category: .morning,
            benefit: "Comprehensive morning supplication for protection and goodness."
        ),
        Dhikr(
            id: "m13",
            arabic: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا، وَبِكَ نَمُوْتُ وَإِلَيْكَ النُّشُورُ",
            transliteration: "Allahumma bika asbahna, wa-bika amsayna, wa-bika nahyaa, wa-bika namootu, wa-ilaykan-nushoor",
            translation: "O Allah, by You we enter the morning and by You we enter the evening, and by You we live and by You we die and unto You is our final return.",
            repetitions: 1,
            source: "Abu Dawud 5068",
            category: .morning,
            benefit: "Acknowledging Allah's control over our day and night."
        )
    ]

    // MARK: - Evening Adhkar (16 entries, matching PWA order)
    static var evening: [Dhikr] = [
        Dhikr(
            id: "e0",
            arabic: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهو الْعَلِيُّ الْعَظِيمُ",
            transliteration: "Allahu la ilaha illa huwal hayyul qayyum, la ta'khudhuhu sinatun wala nawm, lahu ma fis-samawati wama fil-ard, man dhal-ladhi yashfa'u 'indahu illa bi-idhnih, ya'lamu ma bayna aydihim wama khalfahum, wala yuhituna bishay'in min 'ilmihi illa bima sha', wasi'a kursiyyuhus-samawati wal-arda wala ya'uduhu hifdhuhuma, wa huwal 'aliyyul 'adheem",
            translation: "Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
            repetitions: 1,
            source: "Quran 2:255",
            category: .evening,
            benefit: "Recited in the evening for protection until morning."
        ),
        Dhikr(
            id: "e1",
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوهُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            transliteration: "Allahumma anta rabbee La ilaha illa ant, khalaqtanee wa ana 'abduk, wa ana 'ala 'ahdika wa w'adika masta-ta'tu, a'uthubika min sharri ma sana'tu, abu-u laka bi ni'matika 'alayya, wa abu-u bi-dhambi, faghfirlee finnahu laa yaghfirudhunooba illa ant",
            translation: "O Allah! You are my Lord; none has the right to be worshipped but You. You created me and I am Your slave and I am faithful to my covenant, and my commitment to You as far as I am able. I seek Your refuge from the evil of what I have done. I acknowledge before You all of the favours that You have bestowed upon me and I confess to you all my sins. Forgive me, for there is none who can forgive sins except You.",
            repetitions: 1,
            source: "Bukhari 6306",
            category: .evening,
            benefit: "Sayyidul Istighfaar: Whoever recites it at night with firm conviction and dies before morning will be from the people of Paradise."
        ),
        Dhikr(
            id: "e2",
            arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "La ilaha illal-laahu wahdahu laa shareeka lahu, lahul mulku wa-lahul hamdu wa-huwa 'ala kulli shayin qadeer",
            translation: "None has the right to be worshipped but Allah alone Who has no partner. Sovereignty is His and all praise is for Him, and He has full power over all things.",
            repetitions: 10,
            source: "Bukhari 3293 & Muslim 2691",
            category: .evening,
            benefit: "Reward of freeing ten slaves, 100 good deeds, 100 sins erased, and protection from Shaytan till evening."
        ),
        Dhikr(
            id: "e3",
            arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            transliteration: "Subhaanallaahi wa bi hamdihi",
            translation: "Glory is to Allah and Praise is to Him",
            repetitions: 100,
            source: "Bukhari 6405 & Muslim 2691",
            category: .evening,
            benefit: "All sins will be forgiven even if they were as much as the foam of the sea."
        ),
        Dhikr(
            id: "e4",
            arabic: "بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Bismillaahil-ladhi laa yadduru ma'a ismihi shayun fil-ardi walaa fis-samaai wa-huwas samee'ul 'aleem",
            translation: "In the Name of Allah, Who with His Name nothing can cause harm in the Earth nor in the Heavens, and He is the All-Hearing, the All-Knowing.",
            repetitions: 1,
            source: "Ahmad 446 & Tirmidhi 3388",
            category: .evening,
            benefit: "Nothing shall come to harm him on that day and evening."
        ),
        Dhikr(
            id: "e5",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةُ فِي دِينِي وَدُنْيَايَ، وَأَهْلِي وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي",
            transliteration: "Allahumma inni asalukal aafiyata fid-dunya wal aakhirah, Allahumma inni asalukal 'afwa wal 'aafiyata fee deenee wa dunyaay, wa ahlee wa maalee, Allahumas tur 'awratee, wa-aamin raw'aatee, Allahumahfathnee min bayni yaday, wa-min khalfee, wa-'an yameenee, wa-'an shimaalee, wa-min fawqee, wa a'udhu bi-'adhamatika an ughtaala min tahtee",
            translation: "O Allah, I seek Your protection in this world and the next. O Allah, I seek Your forgiveness and Your protection in my religion, in my worldly affairs, in my family and in my wealth. O Allah, conceal my faults and safeguard me from the things which I fear. O Allah, guard me from what is in front of me and behind me, and from my right, and from my left, and from above me, and I seek refuge in Your Greatness from being struck down from beneath me.",
            repetitions: 1,
            source: "Abu Dawud 5074",
            category: .evening,
            benefit: "The Prophet would always recite this whenever he entered upon the morning and evening."
        ),
        Dhikr(
            id: "e6",
            arabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ قُلْ هُوَ اللَّهُ أَحَدٌ (١) اللَّهُ الصَّمَدُ (٢) لَمْ يَلِدْ وَلَمْ يُولَدْ (٣) وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ (٤)",
            transliteration: "Bismillaah-hirahmaan-nirraheem. Qul huwal-laahu Ahad. Allaahus samad. Lam yalid wa lam yuwlad. Wa lam yakullahu kuf-fuw-wan Ahad",
            translation: "In the name of Allah, the Most Compassionate, Most Merciful. Say, He is Allah, One and Indivisible. Allah, the Sustainer needed by all. He has never had offspring, nor was He born. And there is none comparable to Him.",
            repetitions: 3,
            source: "Al-Ikhlas",
            category: .evening,
            benefit: "Suffice him (as a protection) against everything."
        ),
        Dhikr(
            id: "e7",
            arabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ (١) مِن شَرِّ مَا خَلَقَ (٢) وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ (٣) وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ (٤) وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ (٥)",
            transliteration: "Bismillaah-hirahmaan-nirraheem. Qul 'audhu birabbil falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idha waqab. Wa min sharrin naffa-thaati fil 'uqad. Wa min sharri haasidin idha hasad",
            translation: "In the name of Allah, the Most Compassionate, Most Merciful. Say, I seek refuge in the Lord of the daybreak. From the evil of whatever He has created. And from the evil of the night when it grows dark. And from the evil of those witches casting spells by blowing onto knots. And from the evil of an envier when they envy.",
            repetitions: 3,
            source: "Al-Falaq",
            category: .evening,
            benefit: "Suffice him (as a protection) against everything."
        ),
        Dhikr(
            id: "e8",
            arabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ النَّاسِ (١) مَلِكِ النَّاسِ (٢) إِلَهِ النَّاسِ (٣) مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ (٤) الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ (٥) مِنَ الْجِنَّةِ وَالنَّاسِ (٦)",
            transliteration: "Bismillaah-hirahmaan-nirraheem. Qul 'audhu birabbin naas. Malikin-naas. Ilaahin-naas. Min sharril waswaasil khannaas. El-ledhi yuwas-wisu fee sudoorin-naas. Minal jin-nati wan-naas",
            translation: "In the name of Allah, the Most Compassionate, Most Merciful. Say, I seek refuge in the Lord of humankind. The Master of humankind. The God of humankind. From the evil of the lurking whisper. Who whispers into the hearts of humankind. From among jinn and humankind.",
            repetitions: 3,
            source: "An-Nas",
            category: .evening,
            benefit: "Suffice him (as a protection) against everything."
        ),
        Dhikr(
            id: "e9",
            arabic: "رَضِيتُ بِاللَّهِ رَبَّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
            transliteration: "Radeetu billaahi rabban, wa-bil islaami deenan, wa-bi muhammadin sallal-laahu 'alayhi wa sallama nabeeyyan",
            translation: "I am pleased with Allah as my Lord, and with Islam as my Religion, and with Muhammad (Peace and Blessings of Allah be Upon Him) as my Prophet.",
            repetitions: 3,
            source: "Ahmad 18968",
            category: .evening,
            benefit: "Allah has made it binding upon Himself to please him on the Day of Resurrection."
        ),
        Dhikr(
            id: "e10",
            arabic: "اللَّهُمَّ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي وَشَرِّ الشَّيْطَانِ وَشِرْكِهِ وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ",
            transliteration: "Allahumma faatiras samaa-waati wal ard, 'aalimal ghaybi washa-haadah, rabba kulli shayin wa maleekah, ash-hadu allaa-ilaaha illa ant, a'udhu bika min sharri nafsee, wa sharrish shaytaani wa shirkih, wa-an aktarifa 'alaa nafsee sooan, aw ajjuruhu ila muslim",
            translation: "O Allah, Creator of the Heavens and the Earth, Knower of the unseen and evident. Lord of all things and its Possessor. I testify that there is no God worthy of worship except You. I seek refuge in You from the evil of my soul and from the evil of Satan and his helpers. (I seek refuge in You) from bringing evil (sins) upon my soul and from harming any Muslim.",
            repetitions: 1,
            source: "Abu Dawud 5067",
            category: .evening,
            benefit: "The Prophet taught this Dua to Abu Bakr to say every morning and evening."
        ),
        Dhikr(
            id: "e11",
            arabic: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
            transliteration: "Yaa hayuu yaa qayyoom, bi-rahmatika astagheeth, uslihlee sha-nee kullahu wa-laa takil-nee ila nafsee tarfata 'ayn",
            translation: "O Ever Living One, O All-Sustaining One, by Your mercy I call on You to set right all of my affairs. Do not place me in charge of my soul even for the blinking of an eye.",
            repetitions: 1,
            source: "Nasa'i 10405",
            category: .evening,
            benefit: "The Prophet taught this Dua to his daughter Fatima to say every morning and evening."
        ),
        Dhikr(
            id: "e12",
            arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ، وَخَيْرَ مَا بَعْدَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ، وَشَرِّ مَا بَعْدَهَا، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ، وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ",
            transliteration: "Amsaynaa wa-amsal mulku lillah, wal hamdu lillah, laa ilaaha ilal-laahu wahdahoo laa shareeka lah, lahul mulku, wa-lahul hamdu wa-huwa 'ala kulli shayin qadeer, rabbi as-aluka khayra maa fee hadhi-hil laylah, wa khayra ma b'adahaa, wa 'audhu bika min sharri maa fee hadhi-hil laylah, wa sharri maa b'adahaa, rabbi 'audhu bika minal kasal, wa-sooil kibar, rabbi 'audu bika min 'adhaabin fin-naari wa 'adhaabin fil qabr",
            translation: "We have entered the evening and all sovereignty belongs to Allah; Praise be to Allah; None has the right to be worshipped but Allah alone, Who has no partner. To Allah belongs the dominion, and to Him belongs all praise, and He is Able to do all things. My Lord, I ask You for the goodness of this night and that what comes after it, and I seek refuge in You from the evil of this night and that what comes after it. My Lord, I seek refuge in You from laziness and from the feebleness of old age. My Lord, I seek refuge in You from the punishment of the Hellfire, and from the punishment of the grave.",
            repetitions: 1,
            source: "Muslim 2723",
            category: .evening,
            benefit: "Comprehensive evening supplication for protection and goodness."
        ),
        Dhikr(
            id: "e13",
            arabic: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ",
            transliteration: "Allahumma bika amsayna, wa-bika asbahna, wa-bika nahyaa, wa-bika namootu, wa-ilaykal maseer",
            translation: "O Allah, by You we enter the evening and by You we enter the morning, and by You we live and by You we die and unto You is our final return.",
            repetitions: 1,
            source: "Ibn Majah 3868",
            category: .evening,
            benefit: "Acknowledging Allah's control over our day and night."
        ),
        Dhikr(
            id: "e14",
            arabic: "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
            transliteration: "Hasbeeyal-laahu laa ilaaha illa huwa 'alayhi tawakaltu wa-huwa rabbul 'arshil 'adheem",
            translation: "Sufficient for me is Allah; there is no deity except Him. Upon him I have relied, and He is the Lord of the Great Throne.",
            repetitions: 7,
            source: "Abu Dawud 5081",
            category: .evening,
            benefit: "Allah will take care of all of the concerns and worries for the one who recites this seven times every morning and evening."
        ),
        Dhikr(
            id: "e15",
            arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            transliteration: "A'udhu bikalimaatil-laahit taam-maati min sharri maa khalaq",
            translation: "I Seek refuge in the Perfect Words of Allah from the evil of what He has created.",
            repetitions: 1,
            source: "Muslim 2708, 2709",
            category: .evening,
            benefit: "Recited in the evening only. Nothing shall do him any harm until he moves from that place."
        )
    ]

    // MARK: - Daily Categories
    static let dailyCategories: [AdhkarCategory] = [
        .wakeUp, .bathroom, .gettingDressed, .home, .eating, .mosque, .travelling, .wudu, .afterPrayer, .afterAdhan, .sleeping, .sneezing
    ]

    static func adhkar(for category: AdhkarCategory) -> [Dhikr] {
        switch category {
        case .wakeUp:
            return [
                Dhikr(id: "w1",
                      arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
                      transliteration: "Alhamdu lillahil-lathee ahyana ba'da ma amatana wa ilayhin-nushoor",
                      translation: "All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.",
                      repetitions: 1, source: "Bukhari", category: .wakeUp),
            ]
        case .bathroom:
            return [
                Dhikr(id: "d-bath1",
                      arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ",
                      transliteration: "Allahumma innee a'oodhu bika minal-khubuthi wal-khaba'ith",
                      translation: "O Allah, I seek refuge in You from male and female evil spirits.",
                      repetitions: 1, source: "Bukhari 1/45", category: .bathroom,
                      benefit: "The Prophet ﷺ said this shields a person from the evil jinn present in bathrooms."),
                Dhikr(id: "d-bath2",
                      arabic: "غُفْرَانَكَ",
                      transliteration: "Ghufranak",
                      translation: "I seek Your forgiveness.",
                      repetitions: 1, source: "Abu Dawud 1/8", category: .bathroom,
                      benefit: "The Prophet ﷺ said this upon exiting. A small word carrying immense gratitude to Allah.")
            ]
        case .gettingDressed:
            return [
                Dhikr(id: "d-dress1",
                      arabic: "الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ",
                      transliteration: "Alhamdulillahil-ladhee kasanee hadha wa razaqaneehi min ghayri hawlin minnee wa la quwwah",
                      translation: "All praise is for Allah who clothed me with this and provided it without any power or might from me.",
                      repetitions: 1, source: "Abu Dawud 4/41", category: .gettingDressed,
                      benefit: "Whoever says this has their past sins forgiven."),
                Dhikr(id: "d-dress2",
                      arabic: "اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيهِ، أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا صُنِعَ لَهُ",
                      transliteration: "Allahumma lakal-hamdu anta kasawtaneehi, as'aluka min khayrihi wa khayri ma suni'a lah",
                      translation: "O Allah, to You belongs all praise — You have clothed me with it. I ask You for its goodness.",
                      repetitions: 1, source: "Abu Dawud 4/41", category: .gettingDressed,
                      benefit: "A du'a of gratitude for new blessings — attaches every new gift back to Allah.")
            ]
        case .home:
            return [
                Dhikr(id: "d-home1",
                      arabic: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ، لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ",
                      transliteration: "Bismillahi tawakkaltu 'alallah, la hawla wa la quwwata illa billah",
                      translation: "In the name of Allah, I place my trust in Allah. There is no power nor might except with Allah.",
                      repetitions: 1, source: "Abu Dawud 5095", category: .home,
                      benefit: "Whoever says this is told: you are guided, protected, and cared for. Shaytan turns away from him."),
                Dhikr(id: "d-home2",
                      arabic: "بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا",
                      transliteration: "Bismillahi walajna, wa bismillahi kharajna, wa 'alallahi rabbina tawakkalna",
                      translation: "In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we place our trust.",
                      repetitions: 1, source: "Abu Dawud 5096", category: .home,
                      benefit: "Fills the home with barakah and keeps Shaytan away.")
            ]
        case .eating:
            return [
                Dhikr(id: "d-eat1",
                      arabic: "بِسْمِ اللَّهِ",
                      transliteration: "Bismillah",
                      translation: "In the name of Allah.",
                      repetitions: 1, source: "Bukhari 5376", category: .eating,
                      benefit: "Shaytan cannot share in the meal of one who says Bismillah before eating."),
                Dhikr(id: "d-eat2",
                      arabic: "بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ",
                      transliteration: "Bismillahi awwalahu wa akhirah",
                      translation: "In the name of Allah at its beginning and its end.",
                      repetitions: 1, source: "Abu Dawud 3767", category: .eating,
                      benefit: "Shaytan is forced to vomit out what he ate when you remember Allah mid-meal."),
                Dhikr(id: "d-eat3",
                      arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ",
                      transliteration: "Alhamdulillahil-ladhee at'amana wa saqana wa ja'alana muslimeen",
                      translation: "All praise is for Allah who fed us, gave us drink, and made us Muslims.",
                      repetitions: 1, source: "Abu Dawud 3850", category: .eating,
                      benefit: "Gratitude for food is itself an act of worship the Prophet ﷺ practiced at every meal.")
            ]
        case .mosque:
            return [
                Dhikr(id: "d-masjid1",
                      arabic: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
                      transliteration: "Allahumma iftah lee abwaba rahmatik",
                      translation: "O Allah, open the gates of Your mercy for me.",
                      repetitions: 1, source: "Muslim 713", category: .mosque,
                      benefit: "Entering the house of Allah with a request — He opens His mercy to those who ask."),
                Dhikr(id: "d-masjid2",
                      arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
                      transliteration: "Allahumma innee as'aluka min fadlik",
                      translation: "O Allah, I ask You from Your bounty.",
                      repetitions: 1, source: "Muslim 713", category: .mosque,
                      benefit: "Leaving the masjid should not be empty-handed — ask for Allah's provision as you return to the world.")
            ]
        case .travelling:
            return [
                Dhikr(id: "d-travel1",
                      arabic: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
                      transliteration: "Subhanal-ladhee sakhkhara lana hadha wa ma kunna lahu muqrineen, wa inna ila rabbina lamunqaliboon",
                      translation: "Glory be to the One who subjected this to us — we could not have done it ourselves. And to our Lord we shall return.",
                      repetitions: 1, source: "Quran 43:13", category: .travelling,
                      benefit: "The Prophet ﷺ recited this on every journey — acknowledging that all transport is from Allah."),
                Dhikr(id: "d-travel2",
                      arabic: "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى",
                      transliteration: "Allahumma inna nas'aluka fee safarina hadhal-birra wat-taqwa",
                      translation: "O Allah, we ask You on this journey for righteousness and taqwa.",
                      repetitions: 1, source: "Muslim 1342", category: .travelling,
                      benefit: "A comprehensive du'a the Prophet ﷺ taught companions before every travel.")
            ]
        case .wudu:
            return [
                Dhikr(id: "d-wudu1",
                      arabic: "بِسْمِ اللَّهِ",
                      transliteration: "Bismillah",
                      translation: "In the name of Allah.",
                      repetitions: 1, source: "Abu Dawud 101", category: .wudu,
                      benefit: "There is no wudu for the one who does not mention Allah's name upon it."),
                Dhikr(id: "d-wudu2",
                      arabic: "أَشْهَدُ أَنْ لاَّ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّداً عَبْدُهُ وَرَسُولُهُ",
                      transliteration: "Ash-hadu an la ilaha illallahu wahdahu la shareeka lah, wa ash-hadu anna Muhammadan 'abduhu wa rasooluh",
                      translation: "I bear witness that none has the right to be worshipped except Allah alone. And I bear witness that Muhammad is His slave and Messenger.",
                      repetitions: 1, source: "Muslim 234", category: .wudu,
                      benefit: "Whoever says this after wudu has all eight gates of Paradise opened for them.")
            ]
        case .afterPrayer:
            return [
                Dhikr(id: "p1",
                      arabic: "سُبْحَانَ اللَّهِ",
                      transliteration: "SubhanAllah",
                      translation: "Glory be to Allah.",
                      repetitions: 33, source: "Muslim 1/418", category: .afterPrayer,
                      benefit: "Together with Alhamdulillah and Allahu Akbar — fills the scales of deeds."),
                Dhikr(id: "p2",
                      arabic: "الْحَمْدُ لِلَّهِ",
                      transliteration: "Alhamdulillah",
                      translation: "All praise is for Allah.",
                      repetitions: 33, source: "Muslim 1/418", category: .afterPrayer,
                      benefit: "Gratitude to Allah — fills what is between heaven and earth."),
                Dhikr(id: "p3",
                      arabic: "اللَّهُ أَكْبَرُ",
                      transliteration: "Allahu Akbar",
                      translation: "Allah is the Greatest.",
                      repetitions: 33, source: "Muslim 1/418", category: .afterPrayer,
                      benefit: "Proclaiming Allah's greatness — the heaviest on the Scale of deeds."),
                Dhikr(id: "p4",
                      arabic: "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهو عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                      transliteration: "La ilaha illallahu wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu, wa huwa 'ala kulli shayin qadeer",
                      translation: "None has the right to be worshipped except Allah alone, Who has no partner. Sovereignty is His and all praise is for Him, and He has full power over all things.",
                      repetitions: 1, source: "Muslim 1/418", category: .afterPrayer,
                      benefit: "Said after each prayer to complete the 100 — sins forgiven even if like the sea's foam."),
                Dhikr(id: "p5",
                      arabic: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهو الْعَلِيُّ الْعَظِيمُ",
                      transliteration: "Allahu la ilaha illa huwal hayyul qayyum, la ta'khudhuhu sinatun wala nawm, lahu ma fis-samawati wama fil-ard, man dhal-ladhi yashfa'u 'indahu illa bi-idhnih, ya'lamu ma bayna aydihim wama khalfahum, wala yuhituna bishay'in min 'ilmihi illa bima sha', wasi'a kursiyyuhus-samawati wal-arda wala ya'uduhu hifdhuhuma, wa huwal 'aliyyul 'adheem",
                      translation: "Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
                      repetitions: 1, source: "Quran 2:255", category: .afterPrayer,
                      benefit: "Nothing prevents entry to Paradise except death for whoever recites this after each fard prayer.")
            ]
        case .afterAdhan:
            return [
                Dhikr(id: "adhan1",
                      arabic: "اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ، آتِ مُحَمَّدًا نالْوَسِيلَةَ وَالْفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ",
                      transliteration: "Allahumma Rabba hadhihid-da'watit-tammah, was-salatil-qa'imah, ati Muhammadanil-waseelata wal-fadeelah, wab'ath-hu maqaman mahmoodanil-ladhee wa'adtah",
                      translation: "O Allah, Lord of this perfect call and established prayer, grant Muhammad the intercession and the highest degree. Raise him to the praiseworthy station You have promised.",
                      repetitions: 1, source: "Bukhari 614", category: .afterAdhan,
                      benefit: "Whoever says this after the adhan, intercession of the Prophet ﷺ becomes lawful for them on the Day of Judgement."),
                Dhikr(id: "adhan2",
                      arabic: "أشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، رَضِيتُ بِاللَّهِ رَبَّاً وَبِمُحَمَّدٍ نَبِيَّاً وَبِالْإِسْلَامِ دِينًاٌ",
                      transliteration: "Ash-hadu an la ilaha illallahu wahdahu la shareeka lah, wa ash-hadu anna Muhammadan 'abduhu wa rasooluh. Radeetu billahi rabban wa bi-Muhammadin nabiyyan wa bil-Islami deenan",
                      translation: "I testify there is no god but Allah alone, and Muhammad is His servant and messenger. I am pleased with Allah as my Lord, Muhammad as Prophet, and Islam as my religion.",
                      repetitions: 1, source: "Muslim 386", category: .afterAdhan,
                      benefit: "Sins are forgiven for whoever says this.")
            ]
        case .sleeping:
            return [
                Dhikr(id: "s1",
                      arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
                      transliteration: "Bismika Allahumma amootu wa ahya",
                      translation: "In Your name O Allah, I die and I live.",
                      repetitions: 1, source: "Bukhari", category: .sleeping),
            ]
        case .sneezing:
            return [
                Dhikr(id: "d-act1",
                      arabic: "الْحَمْدُ لِلَّهِ",
                      transliteration: "Alhamdulillah",
                      translation: "All praise is for Allah.",
                      repetitions: 1, source: "Bukhari 6224", category: .sneezing,
                      benefit: "The one who sneezes says Alhamdulillah; the listener replies Yarhamukallah (may Allah have mercy on you).")
            ]
        default:
            return []
        }
    }
}
