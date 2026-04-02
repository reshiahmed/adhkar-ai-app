// AdhkarData.swift — Static seed data matching the PWA content

import Foundation

struct AdhkarData {

    // MARK: - Morning Adhkar (13 entries, matching PWA)
    static let morning: [Dhikr] = [
        Dhikr(
            id: "m1",
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            transliteration: "Allahumma anta rabbee la ilaha illa ant, khalaqtanee wa ana 'abduk, wa ana 'ala 'ahdika wa w'adika masta-ta'tu, a'uthubika min sharri ma sana'tu, abu-u laka bi ni'matika 'alayya, wa abu-u bi-dhambi, faghfirlee finnahu laa yaghfirudh-dhunooba illa ant",
            translation: "O Allah! You are my Lord; none has the right to be worshipped but You. You created me and I am Your slave, and I am faithful to my covenant and my promise as much as I can. I seek refuge with You from all the evil I have done. I acknowledge before You all the blessings You have bestowed upon me, and I confess to You all my sins. So forgive me, for verily none can forgive sins except You.",
            repetitions: 1,
            source: "Bukhari",
            category: .morning
        ),
        Dhikr(
            id: "m2",
            arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Asbahna wa asbahal mulku lillah, walhamdu lillah, la ilaha illallah wahdahu la shareeka lah, lahul mulku wa lahul hamdu wa huwa 'ala kulli shay'in qadeer",
            translation: "We have reached the morning and at this very time all sovereignty belongs to Allah. All praise is due to Allah. None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.",
            repetitions: 1,
            source: "Muslim",
            category: .morning
        ),
        Dhikr(
            id: "m3",
            arabic: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ",
            transliteration: "Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namootu wa ilaikan-nushoor",
            translation: "O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.",
            repetitions: 1,
            source: "Abu Dawud, Tirmidhi",
            category: .morning
        ),
        Dhikr(
            id: "m4",
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، عَلَيْكَ تَوَكَّلْتُ وَأَنْتَ رَبُّ الْعَرْشِ الْعَظِيمِ",
            transliteration: "Allahumma anta rabbee la ilaha illa ant, 'alayka tawakkaltu wa anta rabbul 'arshil 'azeem",
            translation: "O Allah, You are my Lord, there is none worthy of worship but You, upon You I rely and You are the Lord of the Magnificent Throne.",
            repetitions: 7,
            source: "Abu Dawud",
            category: .morning
        ),
        Dhikr(
            id: "m5",
            arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Bismillahil-lathee la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i, wa huwas-samee'ul-'aleem",
            translation: "In the name of Allah with Whose name nothing can cause harm in the earth or in the heavens, and He is the All-Hearing, the All-Knowing.",
            repetitions: 3,
            source: "Abu Dawud, Tirmidhi",
            category: .morning
        ),
        Dhikr(
            id: "m6",
            arabic: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلاَمِ دِينًا، وَبِمُحَمَّدٍ صَلَى اللهُ عَلَيهِ وَسَلَّمَ نَبِيًّا",
            transliteration: "Radeetu billahi rabban, wa bil-islami deenan, wa bi-Muhammadin sallallahu 'alayhi wa sallama nabiyyan",
            translation: "I am pleased with Allah as a Lord, and Islam as a religion and Muhammad (peace be upon him) as a Prophet.",
            repetitions: 3,
            source: "Abu Dawud",
            category: .morning
        ),
        Dhikr(
            id: "m7",
            arabic: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
            transliteration: "Ya Hayyu ya Qayyoom, bi rahmatika astaghees, aslih lee sha'nee kullahu wa la takilnee ila nafsee tarfata 'ayn",
            translation: "O Ever Living, O Self-Sustaining and Supporter of all, by Your mercy I seek assistance, rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye.",
            repetitions: 1,
            source: "Hakim",
            category: .morning
        ),
        Dhikr(
            id: "m8",
            arabic: "أَصْبَحْنَا عَلَى فِطْرَةِ الإِسْلاَمِ وَعَلَى كَلِمَةِ الإِخْلاَصِ وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ",
            transliteration: "Asbahna 'ala fitratil-islam, wa 'ala kalimatil-ikhlas, wa 'ala dini nabiyyina Muhammadin sallallahu 'alayhi wa sallam, wa 'ala millati abeena Ibraheema haneefam-musliman wa ma kana minal-mushrikeen",
            translation: "We rise upon the fitrah (natural disposition) of Islam, and the word of sincere devotion, and upon the religion of our Prophet Muhammad (peace be upon him) and the religion of our forefather Ibrahim, who was a Muslim and of true faith and was not of those who associate partners with Allah.",
            repetitions: 1,
            source: "Ahmad",
            category: .morning
        ),
        Dhikr(
            arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            transliteration: "Subhanallahi wa bihamdih",
            translation: "Glory is to Allah and praise is to Him.",
            repetitions: 100,
            source: "Bukhari, Muslim",
            category: .morning
        ),
        Dhikr(
            arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "La ilaha illallah wahdahu la shareeka lah, lahul mulku wa lahul hamdu wa huwa 'ala kulli shay'in qadeer",
            translation: "None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.",
            repetitions: 10,
            source: "Muslim",
            category: .morning
        ),
        Dhikr(
            arabic: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
            transliteration: "Allahumma salli wa sallim 'ala nabiyyina Muhammad",
            translation: "O Allah, send Your prayers and peace upon our Prophet Muhammad.",
            repetitions: 10,
            source: "Tirmidhi",
            category: .morning
        ),
        Dhikr(
            arabic: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ",
            transliteration: "A'oothu billahi minash-shaytanir-rajeem",
            translation: "I seek refuge in Allah from the cursed devil.",
            repetitions: 1,
            source: "Quran 16:98",
            category: .morning
        ),
        Dhikr(
            arabic: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...",
            transliteration: "Allahu la ilaha illa huwal-hayyul-qayyoom...",
            translation: "Ayat al-Kursi — Allah! None has the right to be worshipped but He, the Ever Living, the One Who sustains and protects all that exists...",
            repetitions: 1,
            source: "Bukhari",
            category: .morning
        ),
    ]

    // MARK: - Evening Adhkar (15 entries, matching PWA)
    static let evening: [Dhikr] = [
        Dhikr(
            id: "e1",
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            transliteration: "Allahumma anta rabbee la ilaha illa ant...",
            translation: "O Allah! You are my Lord; none has the right to be worshipped but You. You created me and I am Your slave...",
            repetitions: 1,
            source: "Bukhari",
            category: .evening
        ),
        Dhikr(
            arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Amsayna wa amsal mulku lillah, walhamdu lillah, la ilaha illallah wahdahu la shareeka lah...",
            translation: "We have reached the evening and at this very time all sovereignty belongs to Allah. All praise is due to Allah...",
            repetitions: 1,
            source: "Muslim",
            category: .evening
        ),
        Dhikr(
            arabic: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ",
            transliteration: "Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namootu wa ilayk-al-maseer",
            translation: "O Allah, by You we enter the evening and by You we enter the morning, by You we live and by You we die, and to You is our return.",
            repetitions: 1,
            source: "Abu Dawud, Tirmidhi",
            category: .evening
        ),
        Dhikr(
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، عَلَيْكَ تَوَكَّلْتُ وَأَنْتَ رَبُّ الْعَرْشِ الْعَظِيمِ",
            transliteration: "Allahumma anta rabbee la ilaha illa ant, 'alayka tawakkaltu wa anta rabbul 'arshil 'azeem",
            translation: "O Allah, You are my Lord, there is none worthy of worship but You, upon You I rely and You are the Lord of the Magnificent Throne.",
            repetitions: 7,
            source: "Abu Dawud",
            category: .evening
        ),
        Dhikr(
            arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Bismillahil-lathee la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i, wa huwas-samee'ul-'aleem",
            translation: "In the name of Allah with Whose name nothing can cause harm in the earth or in the heavens, and He is the All-Hearing, the All-Knowing.",
            repetitions: 3,
            source: "Abu Dawud, Tirmidhi",
            category: .evening
        ),
        Dhikr(
            arabic: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلاَمِ دِينًا، وَبِمُحَمَّدٍ صَلَى اللهُ عَلَيهِ وَسَلَّمَ نَبِيًّا",
            transliteration: "Radeetu billahi rabban, wa bil-islami deenan, wa bi-Muhammadin sallallahu 'alayhi wa sallama nabiyyan",
            translation: "I am pleased with Allah as a Lord, and Islam as a religion and Muhammad (peace be upon him) as a Prophet.",
            repetitions: 3,
            source: "Abu Dawud",
            category: .evening
        ),
        Dhikr(
            arabic: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
            transliteration: "Ya Hayyu ya Qayyoom, bi rahmatika astaghees, aslih lee sha'nee kullahu wa la takilnee ila nafsee tarfata 'ayn",
            translation: "O Ever Living, O Self-Sustaining and Supporter of all, by Your mercy I seek assistance, rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye.",
            repetitions: 1,
            source: "Hakim",
            category: .evening
        ),
        Dhikr(
            arabic: "أَمْسَيْنَا عَلَى فِطْرَةِ الإِسْلاَمِ وَعَلَى كَلِمَةِ الإِخْلاَصِ وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ",
            transliteration: "Amsayna 'ala fitratil-islam...",
            translation: "We enter the evening upon the fitrah of Islam, and the word of sincere devotion, and upon the religion of our Prophet Muhammad (peace be upon him)...",
            repetitions: 1,
            source: "Ahmad",
            category: .evening
        ),
        Dhikr(
            arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            transliteration: "Subhanallahi wa bihamdih",
            translation: "Glory is to Allah and praise is to Him.",
            repetitions: 100,
            source: "Bukhari, Muslim",
            category: .evening
        ),
        Dhikr(
            arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "La ilaha illallah wahdahu la shareeka lah...",
            translation: "None has the right to be worshipped except Allah, alone, without partner.",
            repetitions: 10,
            source: "Muslim",
            category: .evening
        ),
        Dhikr(
            arabic: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
            transliteration: "Allahumma salli wa sallim 'ala nabiyyina Muhammad",
            translation: "O Allah, send Your prayers and peace upon our Prophet Muhammad.",
            repetitions: 10,
            source: "Tirmidhi",
            category: .evening
        ),
        Dhikr(
            arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            transliteration: "A'oothu bikalimatillahit-tammati min sharri ma khalaq",
            translation: "I seek refuge in the Perfect Words of Allah from the evil of what He has created.",
            repetitions: 3,
            source: "Muslim",
            category: .evening
        ),
        Dhikr(
            arabic: "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ",
            transliteration: "Allahumma 'aafini fi badani, Allahumma 'aafini fi sam'ee, Allahumma 'aafini fi basari, la ilaha illa ant",
            translation: "O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. There is none worthy of worship but You.",
            repetitions: 3,
            source: "Abu Dawud",
            category: .evening
        ),
        Dhikr(
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ",
            transliteration: "Allahumma inni as'alukal-'afwa wal-'afiyata fid-dunya wal-akhirah",
            translation: "O Allah, I ask You for forgiveness and well-being in this world and in the Hereafter.",
            repetitions: 1,
            source: "Abu Dawud, Ibn Majah",
            category: .evening
        ),
        Dhikr(
            arabic: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...",
            transliteration: "Allahu la ilaha illa huwal-hayyul-qayyoom...",
            translation: "Ayat al-Kursi — Allah! None has the right to be worshipped but He, the Ever Living...",
            repetitions: 1,
            source: "Bukhari",
            category: .evening
        ),
    ]

    // MARK: - Daily Categories
    static let dailyCategories: [AdhkarCategory] = [
        .wakeUp, .bathroom, .gettingDressed, .eating, .sleeping, .travelling,
        .rain, .mosque, .greeting, .sneezing,
    ]

    static func adhkar(for category: AdhkarCategory) -> [Dhikr] {
        switch category {
        case .wakeUp:
            return [
                Dhikr(arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
                      transliteration: "Alhamdu lillahil-lathee ahyana ba'da ma amatana wa ilayhin-nushoor",
                      translation: "All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.",
                      repetitions: 1, source: "Bukhari", category: .wakeUp),
            ]
        case .bathroom:
            return [
                Dhikr(arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ",
                      transliteration: "Allahumma innee a'oothu bika minal-khubthi wal-khaba'ith",
                      translation: "O Allah, I seek refuge with You from male and female devils.",
                      repetitions: 1, source: "Bukhari, Muslim", category: .bathroom),
            ]
        case .eating:
            return [
                Dhikr(arabic: "بِسْمِ اللَّهِ",
                      transliteration: "Bismillah",
                      translation: "In the name of Allah.",
                      repetitions: 1, source: "Abu Dawud", category: .eating),
                Dhikr(arabic: "اللَّهُمَّ بَارِكْ لَنَا فِيهِ وَأَطْعِمْنَا خَيْرًا مِنْهُ",
                      transliteration: "Allahumma barik lana feehi wa at'imna khayran minh",
                      translation: "O Allah, bless it for us and provide us with something better than it.",
                      repetitions: 1, source: "Tirmidhi", category: .eating),
            ]
        case .sleeping:
            return [
                Dhikr(arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
                      transliteration: "Bismika Allahumma amootu wa ahya",
                      translation: "In Your name O Allah, I die and I live.",
                      repetitions: 1, source: "Bukhari", category: .sleeping),
            ]
        case .travelling:
            return [
                Dhikr(arabic: "اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ",
                      transliteration: "Allahu Akbar, Allahu Akbar, Allahu Akbar, subhanal-lathee sakhkhara lana hatha wa ma kunna lahu muqrineen wa inna ila rabbina lamunqaliboon",
                      translation: "Allah is the greatest, Allah is the greatest, Allah is the greatest. How perfect He is, the One Who has placed this (transport) at our service, and we ourselves would not have been capable of that, and to our Lord is our final destiny.",
                      repetitions: 1, source: "Muslim", category: .travelling),
            ]
        default:
            return []
        }
    }
}
