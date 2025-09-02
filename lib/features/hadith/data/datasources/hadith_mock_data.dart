import '../../domain/entities/hadith_book.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/entities/hadith_topic.dart';

/// Mock data provider for Hadith module development
/// This data mimics the structure and content from iHadis.com
class HadithMockData {
  
  /// Get all hadith books (mimicking iHadis.com books)
  static List<HadithBook> getHadithBooks() {
    return [
      const HadithBook(
        id: 'bukhari',
        name: 'Sahih al-Bukhari',
        nameBengali: 'সহিহ বুখারী',
        nameArabic: 'صحيح البخاري',
        nameUrdu: 'صحیح بخاری',
        shortName: 'B',
        description: 'The most authentic collection of Hadith',
        descriptionBengali: 'হাদিসের সবচেয়ে নির্ভরযোগ্য সংকলন',
        totalHadiths: 7544,
        compiler: 'Imam al-Bukhari',
        compilerBengali: 'ইমাম বুখারী',
        isPopular: true,
        order: 1,
      ),
      const HadithBook(
        id: 'muslim',
        name: 'Sahih Muslim',
        nameBengali: 'সহিহ মুসলিম',
        nameArabic: 'صحيح مسلم',
        nameUrdu: 'صحیح مسلم',
        shortName: 'M',
        description: 'Second most authentic collection after Bukhari',
        descriptionBengali: 'বুখারীর পর দ্বিতীয় সবচেয়ে নির্ভরযোগ্য সংকলন',
        totalHadiths: 7452,
        compiler: 'Imam Muslim',
        compilerBengali: 'ইমাম মুসলিম',
        isPopular: true,
        order: 2,
      ),
      const HadithBook(
        id: 'nasai',
        name: 'Sunan an-Nasa\'i',
        nameBengali: 'সুনানে আন-নাসায়ী',
        nameArabic: 'سنن النسائي',
        nameUrdu: 'سنن نسائی',
        shortName: 'N',
        description: 'Collection focusing on jurisprudence',
        descriptionBengali: 'ফিকহ বিষয়ক হাদিসের সংকলন',
        totalHadiths: 5757,
        compiler: 'Imam an-Nasa\'i',
        compilerBengali: 'ইমাম নাসায়ী',
        isPopular: true,
        order: 3,
      ),
      const HadithBook(
        id: 'abu-dawud',
        name: 'Sunan Abu Dawud',
        nameBengali: 'সুনানে আবু দাউদ',
        nameArabic: 'سنن أبي داود',
        nameUrdu: 'سنن ابو داؤد',
        shortName: 'A',
        description: 'Important collection of legal traditions',
        descriptionBengali: 'আইনগত ঐতিহ্যের গুরুত্বপূর্ণ সংকলন',
        totalHadiths: 5274,
        compiler: 'Imam Abu Dawud',
        compilerBengali: 'ইমাম আবু দাউদ',
        isPopular: true,
        order: 4,
      ),
      const HadithBook(
        id: 'tirmidhi',
        name: 'Jami\' at-Tirmidhi',
        nameBengali: 'জামি আত-তিরমিজি',
        nameArabic: 'جامع الترمذي',
        nameUrdu: 'جامع ترمذی',
        shortName: 'T',
        description: 'Contains commentary on hadith authenticity',
        descriptionBengali: 'হাদিসের সত্যতা সম্পর্কে ভাষ্য সহ',
        totalHadiths: 3956,
        compiler: 'Imam at-Tirmidhi',
        compilerBengali: 'ইমাম তিরমিজি',
        isPopular: true,
        order: 5,
      ),
      const HadithBook(
        id: 'ibn-majah',
        name: 'Sunan Ibn Majah',
        nameBengali: 'সুনানে ইবনে মাজাহ',
        nameArabic: 'سنن ابن ماجه',
        nameUrdu: 'سنن ابن ماجہ',
        shortName: 'I',
        description: 'The sixth book of Kutub al-Sittah',
        descriptionBengali: 'কুতুব সিত্তাহর ষষ্ঠ গ্রন্থ',
        totalHadiths: 4341,
        compiler: 'Ibn Majah',
        compilerBengali: 'ইবনে মাজাহ',
        isPopular: true,
        order: 6,
      ),
      const HadithBook(
        id: 'muwatta-malik',
        name: 'Muwatta Malik',
        nameBengali: 'মুয়াত্তা মালিক',
        nameArabic: 'موطأ مالك',
        nameUrdu: 'موطا مالک',
        shortName: 'Ma',
        description: 'The first written collection of hadith',
        descriptionBengali: 'প্রথম লিখিত হাদিস সংকলন',
        totalHadiths: 1720,
        compiler: 'Imam Malik',
        compilerBengali: 'ইমাম মালিক',
        isPopular: false,
        order: 7,
      ),
    ];
  }

  /// Get featured hadith of the day
  static HadithEntity getFeaturedHadith() {
    return const HadithEntity(
      id: 'bukhari-1',
      hadithNumber: '1',
      arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى دُنْيَا يُصِيبُهَا، أَوْ إِلَى امْرَأَةٍ يَنْكِحُهَا، فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ',
      bengaliText: 'কর্মের প্রতিদান নির্ভর করে নিয়তের উপর, এবং প্রত্যেক ব্যক্তির জন্য রয়েছে সে যা নিয়ত করেছে। যে ব্যক্তি দুনিয়াবী স্বার্থে বা একজন মহিলার সাথে বিবাহ করার উদ্দেশ্যে হিজরত করেছে, তার হিজরত ঐ উদ্দেশ্যেই সীমাবদ্ধ থাকবে যা সে উদ্দেশ্য করেছিল।',
      englishText: 'Actions are judged by intentions, and each person will be rewarded according to their intention. So whoever migrates for worldly gain or to marry a woman, their migration will be for whatever they migrated for.',
      urduText: 'اعمال کا دارومدار نیتوں پر ہے اور ہر شخص کو وہی ملے گا جس کی اس نے نیت کی۔ پس جس کی ہجرت دنیا حاصل کرنے کے لیے یا کسی عورت سے شادی کرنے کے لیے ہو تو اس کی ہجرت اسی چیز کے لیے ہے جس کے لیے اس نے ہجرت کی۔',
      bookId: 'bukhari',
      bookName: 'Sahih al-Bukhari',
      bookNameBengali: 'সহিহ বুখারী',
      bookShortName: 'B',
      chapterName: 'Revelation',
      chapterNameBengali: 'ওহী',
      chapterNumber: '1',
      narrator: 'Umar ibn al-Khattab',
      narratorBengali: 'উমর ইবনে খাত্তাব',
      grade: 'Sahih',
      gradeBengali: 'সহিহ',
      gradeColor: '#2E7D32',
      topics: ['Intention', 'Actions', 'Migration'],
      topicsBengali: ['নিয়ত', 'আমল', 'হিজরত'],
      explanation: 'This is the first hadith in Bukhari and emphasizes the fundamental Islamic principle that actions are judged by intentions.',
      explanationBengali: 'এটি বুখারী শরীফের প্রথম হাদিস এবং এটি মৌলিক ইসলামী নীতির উপর জোর দেয় যে কাজগুলো নিয়ত অনুযায়ী বিচার করা হয়।',
      reference: 'Sahih al-Bukhari 1',
      referenceBengali: 'সহিহ বুখারী ১',
      keywords: ['intention', 'niyyah', 'actions', 'migration', 'hijra'],
      keywordsBengali: ['নিয়ত', 'আমল', 'হিজরত'],
    );
  }

  /// Get sample hadiths for a book
  static List<HadithEntity> getHadithsForBook(String bookId, {int limit = 20}) {
    final hadiths = <HadithEntity>[];
    
    if (bookId == 'bukhari') {
      hadiths.addAll([
        getFeaturedHadith(),
        const HadithEntity(
          id: 'bukhari-2',
          hadithNumber: '2',
          arabicText: 'عَنْ عَبْدِ اللَّهِ بْنِ عَمْرٍو أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم قَالَ: "أَرْبَعٌ مَنْ كُنَّ فِيهِ كَانَ مُنَافِقًا خَالِصًا"',
          bengaliText: 'আবদুল্লাহ ইবনে আমর (রাঃ) থেকে বর্ণিত, রাসূলুল্লাহ (সাঃ) বলেছেন: "চারটি বৈশিষ্ট্য যার মধ্যে থাকবে সে পূর্ণ মুনাফিক।"',
          englishText: 'Abdullah ibn Amr reported that the Messenger of Allah (peace be upon him) said: "Four traits, whoever has them is a pure hypocrite."',
          urduText: 'عبداللہ بن عمرو سے روایت ہے کہ رسول اللہ صلی اللہ علیہ وسلم نے فرمایا: "چار خصلتیں جس میں ہوں وہ خالص منافق ہے۔"',
          bookId: 'bukhari',
          bookName: 'Sahih al-Bukhari',
          bookNameBengali: 'সহিহ বুখারী',
          bookShortName: 'B',
          chapterName: 'Faith',
          chapterNameBengali: 'ঈমান',
          chapterNumber: '2',
          narrator: 'Abdullah ibn Amr',
          narratorBengali: 'আবদুল্লাহ ইবনে আমর',
          grade: 'Sahih',
          gradeBengali: 'সহিহ',
          gradeColor: '#2E7D32',
          topics: ['Faith', 'Hypocrisy', 'Character'],
          topicsBengali: ['ঈমান', 'মুনাফিকি', 'চরিত্র'],
          explanation: 'This hadith warns about the characteristics of hypocrisy.',
          explanationBengali: 'এই হাদিসটি মুনাফিকির বৈশিষ্ট্য সম্পর্কে সতর্ক করে।',
          reference: 'Sahih al-Bukhari 2',
          referenceBengali: 'সহিহ বুখারী ২',
          keywords: ['faith', 'iman', 'hypocrisy', 'character'],
          keywordsBengali: ['ঈমান', 'মুনাফিকি', 'চরিত্র'],
        ),
        // Add more hadiths...
      ]);
    } else if (bookId == 'muslim') {
      hadiths.addAll([
        const HadithEntity(
          id: 'muslim-19',
          hadithNumber: '19',
          arabicText: 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
          bengaliText: 'তোমাদের কেউ মুমিন হতে পারবে না যতক্ষণ না সে নিজের জন্য যা কামনা করে, তা তার ভাইয়ের জন্যও কামনা করে।',
          englishText: 'None of you believes until he loves for his brother what he loves for himself.',
          urduText: 'تم میں سے کوئی شخص اس وقت تک مومن نہیں ہو سکتا جب تک وہ اپنے بھائی کے لیے وہی پسند نہ کرے جو اپنے لیے پسند کرتا ہے۔',
          bookId: 'muslim',
          bookName: 'Sahih Muslim',
          bookNameBengali: 'সহিহ মুসলিম',
          bookShortName: 'M',
          chapterName: 'Faith',
          chapterNameBengali: 'ঈমান',
          chapterNumber: '1',
          narrator: 'Anas ibn Malik',
          narratorBengali: 'আনাস ইবনে মালিক',
          grade: 'Sahih',
          gradeBengali: 'সহিহ',
          gradeColor: '#2E7D32',
          topics: ['Faith', 'Brotherhood', 'Love'],
          topicsBengali: ['ঈমান', 'ভ্রাতৃত্ব', 'ভালোবাসা'],
          explanation: 'This hadith emphasizes the importance of loving others as you love yourself.',
          explanationBengali: 'এই হাদিসটি নিজের মতো অন্যদের ভালোবাসার গুরুত্বের উপর জোর দেয়।',
          reference: 'Sahih Muslim 19',
          referenceBengali: 'সহিহ মুসলিম ১৯',
          keywords: ['faith', 'brotherhood', 'love', 'belief'],
          keywordsBengali: ['ঈমান', 'ভ্রাতৃত্ব', 'ভালোবাসা'],
        ),
      ]);
    }
    
    return hadiths.take(limit).toList();
  }

  /// Get hadith topics (subject-wise categorization)
  static List<HadithTopic> getHadithTopics() {
    return [
      const HadithTopic(
        id: 'aqidah',
        name: 'Aqidah',
        nameBengali: 'আকিদা',
        nameArabic: 'عقيدة',
        nameUrdu: 'عقیدہ',
        description: 'Islamic beliefs and theology',
        descriptionBengali: 'ইসলামী বিশ্বাস ও ধর্মতত্ত্ব',
        totalHadiths: 7,
        iconName: 'star',
        colorCode: '#2E7D32',
        isPopular: true,
        order: 1,
        keywords: ['belief', 'theology', 'faith'],
        keywordsBengali: ['বিশ্বাস', 'ধর্মতত্ত্ব', 'ঈমান'],
      ),
      const HadithTopic(
        id: 'iman',
        name: 'Faith',
        nameBengali: 'ঈমান',
        nameArabic: 'إيمان',
        nameUrdu: 'ایمان',
        description: 'Faith and belief in Islam',
        descriptionBengali: 'ইসলামে ঈমান ও বিশ্বাস',
        totalHadiths: 5,
        iconName: 'favorite',
        colorCode: '#C6A700',
        isPopular: true,
        order: 2,
        keywords: ['faith', 'belief', 'iman'],
        keywordsBengali: ['ঈমান', 'বিশ্বাস'],
      ),
      const HadithTopic(
        id: 'purification',
        name: 'Purification',
        nameBengali: 'পবিত্রতা',
        nameArabic: 'طهارة',
        nameUrdu: 'طہارت',
        description: 'Ritual purification and cleanliness',
        descriptionBengali: 'আনুষ্ঠানিক পবিত্রতা ও পরিচ্ছন্নতা',
        totalHadiths: 12,
        iconName: 'water_drop',
        colorCode: '#26A69A',
        isPopular: true,
        order: 3,
        keywords: ['purification', 'cleanliness', 'wudu'],
        keywordsBengali: ['পবিত্রতা', 'পরিচ্ছন্নতা', 'অজু'],
      ),
      const HadithTopic(
        id: 'hadith-stories',
        name: 'Hadith Stories',
        nameBengali: 'হাদিসের গল্প',
        nameArabic: 'قصص الحديث',
        nameUrdu: 'حدیث کی کہانیاں',
        description: 'Narratives and stories from Hadith',
        descriptionBengali: 'হাদিস থেকে বর্ণনা ও গল্প',
        totalHadiths: 31,
        iconName: 'auto_stories',
        colorCode: '#FF7043',
        isPopular: true,
        order: 4,
        keywords: ['stories', 'narratives', 'qasas'],
        keywordsBengali: ['গল্প', 'বর্ণনা', 'কাসাস'],
      ),
      const HadithTopic(
        id: 'salat',
        name: 'Prayer',
        nameBengali: 'সালাত',
        nameArabic: 'صلاة',
        nameUrdu: 'نماز',
        description: 'Islamic prayer and worship',
        descriptionBengali: 'ইসলামী নামাজ ও ইবাদত',
        totalHadiths: 45,
        iconName: 'mosque',
        colorCode: '#6B8E23',
        isPopular: true,
        order: 5,
        keywords: ['prayer', 'salat', 'worship'],
        keywordsBengali: ['নামাজ', 'সালাত', 'ইবাদত'],
      ),
      const HadithTopic(
        id: 'ethics',
        name: 'Ethics and Morality',
        nameBengali: 'নৈতিকতা ও আদব',
        nameArabic: 'أخلاق وآداب',
        nameUrdu: 'اخلاق و آداب',
        description: 'Islamic ethics and moral conduct',
        descriptionBengali: 'ইসলামী নৈতিকতা ও আদব-কায়দা',
        totalHadiths: 67,
        iconName: 'psychology',
        colorCode: '#8B6F47',
        isPopular: true,
        order: 6,
        keywords: ['ethics', 'morality', 'akhlaq'],
        keywordsBengali: ['নৈতিকতা', 'আদব', 'আখলাক'],
      ),
      const HadithTopic(
        id: 'family',
        name: 'Family and Marriage',
        nameBengali: 'পরিবার ও বিবাহ',
        nameArabic: 'الأسرة والزواج',
        nameUrdu: 'خاندان اور نکاح',
        description: 'Family relationships and marriage',
        descriptionBengali: 'পারিবারিক সম্পর্ক ও বিবাহ',
        totalHadiths: 28,
        iconName: 'family_restroom',
        colorCode: '#D32F2F',
        isPopular: false,
        order: 7,
        keywords: ['family', 'marriage', 'nikah'],
        keywordsBengali: ['পরিবার', 'বিবাহ', 'নিকাহ'],
      ),
      const HadithTopic(
        id: 'business',
        name: 'Business and Trade',
        nameBengali: 'ব্যবসা ও বাণিজ্য',
        nameArabic: 'التجارة والأعمال',
        nameUrdu: 'کاروبار اور تجارت',
        description: 'Islamic principles of business',
        descriptionBengali: 'ব্যবসার ইসলামী নীতিমালা',
        totalHadiths: 19,
        iconName: 'business',
        colorCode: '#7B1FA2',
        isPopular: false,
        order: 8,
        keywords: ['business', 'trade', 'commerce'],
        keywordsBengali: ['ব্যবসা', 'বাণিজ্য', 'লেনদেন'],
      ),
    ];
  }

  /// Search hadiths by query
  static List<HadithEntity> searchHadiths(String query, {int limit = 20}) {
    final lowerQuery = query.toLowerCase();
    final allHadiths = <HadithEntity>[];
    
    // Add hadiths from all books
    for (final book in getHadithBooks()) {
      allHadiths.addAll(getHadithsForBook(book.id));
    }
    
    // Filter hadiths based on query
    final filteredHadiths = allHadiths.where((hadith) {
      return hadith.bengaliText.toLowerCase().contains(lowerQuery) ||
             hadith.englishText.toLowerCase().contains(lowerQuery) ||
             hadith.arabicText.contains(lowerQuery) ||
             (hadith.topics.isNotEmpty && hadith.topics.any((topic) => topic.toLowerCase().contains(lowerQuery))) ||
             (hadith.topicsBengali.isNotEmpty && hadith.topicsBengali.any((topic) => topic.toLowerCase().contains(lowerQuery))) ||
             (hadith.keywords.isNotEmpty && hadith.keywords.any((keyword) => keyword.toLowerCase().contains(lowerQuery))) ||
             (hadith.keywordsBengali.isNotEmpty && hadith.keywordsBengali.any((keyword) => keyword.toLowerCase().contains(lowerQuery)));
    }).toList();
    
    return filteredHadiths.take(limit).toList();
  }

  /// Get popular/trending hadiths
  static List<HadithEntity> getPopularHadiths({int limit = 10}) {
    return [
      getFeaturedHadith(),
      ...getHadithsForBook('muslim', limit: 3),
      ...getHadithsForBook('abu-dawud', limit: 3),
      ...getHadithsForBook('tirmidhi', limit: 3),
    ].take(limit).toList();
  }

  /// Get all hadiths from all books (for search and detail lookup)
  static List<HadithEntity> getAllHadiths() {
    final allHadiths = <HadithEntity>[];
    final books = getHadithBooks();
    
    for (final book in books) {
      allHadiths.addAll(getHadithsForBook(book.id, limit: 100));
    }
    
    return allHadiths;
  }
}
