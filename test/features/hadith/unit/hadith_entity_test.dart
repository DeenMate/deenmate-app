import 'package:flutter_test/flutter_test.dart';
import 'package:deen_mate/features/hadith/domain/entities/hadith_simple.dart';

void main() {
  group('Hadith Entity Tests', () {
    test('should create Hadith with all required fields', () {
      final hadith = Hadith(
        id: 'test_id',
        hadithNumber: '1',
        arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        bengaliText: 'পরম করুণাময় অসীম দয়ালু আল্লাহর নামে',
        englishText: 'In the name of Allah, the Most Gracious, the Most Merciful',
        urduText: 'اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے',
        collection: 'bukhari',
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Abu Huraira',
        narratorBengali: 'আবু হুরাইরা',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['faith', 'revelation'],
        topicsBengali: ['ঈমান', 'ওহী'],
        explanation: 'This hadith explains...',
        explanationBengali: 'এই হাদীস ব্যাখ্যা করে...',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: 'https://example.com/audio.mp3',
        arabicAudioUrl: 'https://example.com/arabic.mp3',
        bengaliAudioUrl: 'https://example.com/bengali.mp3',
        englishAudioUrl: 'https://example.com/english.mp3',
        urduAudioUrl: 'https://example.com/urdu.mp3',
        metadata: {'source': 'sunnah.com'},
      );

      expect(hadith.id, equals('test_id'));
      expect(hadith.hadithNumber, equals('1'));
      expect(hadith.arabicText, equals('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'));
      expect(hadith.bengaliText, equals('পরম করুণাময় অসীম দয়ালু আল্লাহর নামে'));
      expect(hadith.collection, equals('bukhari'));
      expect(hadith.isBookmarked, isFalse);
      expect(hadith.readCount, equals(0));
    });

    test('should create HadithCollection with all required fields', () {
      final collection = HadithCollection(
        id: 'bukhari',
        name: 'Sahih al-Bukhari',
        nameBengali: 'সহীহ বুখারী',
        nameArabic: 'صحيح البخاري',
        nameEnglish: 'Sahih al-Bukhari',
        nameUrdu: 'صحیح بخاری',
        description: 'The most authentic collection of hadiths',
        descriptionBengali: 'হাদীসের সবচেয়ে নির্ভরযোগ্য সংকলন',
        totalHadiths: 7563,
        author: 'Imam Bukhari',
        authorBengali: 'ইমাম বুখারী',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        books: ['Book 1', 'Book 2'],
        booksBengali: ['কিতাব ১', 'কিতাব ২'],
        coverImage: 'assets/images/bukhari.jpg',
        isAvailable: true,
      );

      expect(collection.id, equals('bukhari'));
      expect(collection.nameBengali, equals('সহীহ বুখারী'));
      expect(collection.totalHadiths, equals(7563));
      expect(collection.isAvailable, isTrue);
    });

    test('should create HadithSearchResult with all required fields', () {
      final hadith = Hadith(
        id: 'test_id',
        hadithNumber: '1',
        arabicText: 'Test Arabic',
        bengaliText: 'টেস্ট বাংলা',
        englishText: 'Test English',
        urduText: 'Test Urdu',
        collection: 'bukhari',
        bookName: 'Test Book',
        bookNameBengali: 'টেস্ট বই',
        chapterName: 'Test Chapter',
        chapterNameBengali: 'টেস্ট অধ্যায়',
        narrator: 'Test Narrator',
        narratorBengali: 'টেস্ট বর্ণনাকারী',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['test'],
        topicsBengali: ['টেস্ট'],
        explanation: 'Test explanation',
        explanationBengali: 'টেস্ট ব্যাখ্যা',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: 'https://example.com/audio.mp3',
        arabicAudioUrl: 'https://example.com/arabic.mp3',
        bengaliAudioUrl: 'https://example.com/bengali.mp3',
        englishAudioUrl: 'https://example.com/english.mp3',
        urduAudioUrl: 'https://example.com/urdu.mp3',
        metadata: {},
      );

      final searchResult = HadithSearchResult(
        hadiths: [hadith],
        totalResults: 1,
        currentPage: 1,
        totalPages: 1,
        query: 'test',
        filters: ['collection: bukhari'],
      );

      expect(searchResult.hadiths.length, equals(1));
      expect(searchResult.totalResults, equals(1));
      expect(searchResult.query, equals('test'));
      expect(searchResult.filters, contains('collection: bukhari'));
    });

    test('should convert Hadith to and from JSON', () {
      final originalHadith = Hadith(
        id: 'test_id',
        hadithNumber: '1',
        arabicText: 'Test Arabic',
        bengaliText: 'টেস্ট বাংলা',
        englishText: 'Test English',
        urduText: 'Test Urdu',
        collection: 'bukhari',
        bookName: 'Test Book',
        bookNameBengali: 'টেস্ট বই',
        chapterName: 'Test Chapter',
        chapterNameBengali: 'টেস্ট অধ্যায়',
        narrator: 'Test Narrator',
        narratorBengali: 'টেস্ট বর্ণনাকারী',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['test'],
        topicsBengali: ['টেস্ট'],
        explanation: 'Test explanation',
        explanationBengali: 'টেস্ট ব্যাখ্যা',
        isBookmarked: false,
        lastReadAt: DateTime(2024, 1, 1),
        readCount: 5,
        audioUrl: 'https://example.com/audio.mp3',
        arabicAudioUrl: 'https://example.com/arabic.mp3',
        bengaliAudioUrl: 'https://example.com/bengali.mp3',
        englishAudioUrl: 'https://example.com/english.mp3',
        urduAudioUrl: 'https://example.com/urdu.mp3',
        metadata: {'test': 'value'},
      );

      final json = originalHadith.toJson();
      final restoredHadith = Hadith.fromJson(json);

      expect(restoredHadith.id, equals(originalHadith.id));
      expect(restoredHadith.bengaliText, equals(originalHadith.bengaliText));
      expect(restoredHadith.readCount, equals(originalHadith.readCount));
      expect(restoredHadith.isBookmarked, equals(originalHadith.isBookmarked));
    });

    test('should update Hadith with copyWith', () {
      final originalHadith = Hadith(
        id: 'test_id',
        hadithNumber: '1',
        arabicText: 'Test Arabic',
        bengaliText: 'টেস্ট বাংলা',
        englishText: 'Test English',
        urduText: 'Test Urdu',
        collection: 'bukhari',
        bookName: 'Test Book',
        bookNameBengali: 'টেস্ট বই',
        chapterName: 'Test Chapter',
        chapterNameBengali: 'টেস্ট অধ্যায়',
        narrator: 'Test Narrator',
        narratorBengali: 'টেস্ট বর্ণনাকারী',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['test'],
        topicsBengali: ['টেস্ট'],
        explanation: 'Test explanation',
        explanationBengali: 'টেস্ট ব্যাখ্যা',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: 'https://example.com/audio.mp3',
        arabicAudioUrl: 'https://example.com/arabic.mp3',
        bengaliAudioUrl: 'https://example.com/bengali.mp3',
        englishAudioUrl: 'https://example.com/english.mp3',
        urduAudioUrl: 'https://example.com/urdu.mp3',
        metadata: {},
      );

      final updatedHadith = originalHadith.copyWith(
        isBookmarked: true,
        readCount: 10,
        bengaliText: 'আপডেটেড টেস্ট বাংলা',
      );

      expect(updatedHadith.isBookmarked, isTrue);
      expect(updatedHadith.readCount, equals(10));
      expect(updatedHadith.bengaliText, equals('আপডেটেড টেস্ট বাংলা'));
      expect(updatedHadith.id, equals(originalHadith.id)); // Unchanged
      expect(updatedHadith.arabicText, equals(originalHadith.arabicText)); // Unchanged
    });
  });
}
