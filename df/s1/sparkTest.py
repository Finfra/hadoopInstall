from pyspark import SparkContext, SparkConf

# 기존 SparkContext 가져오기
conf = SparkConf().setAppName("WordCount").setMaster("local")
sc = SparkContext.getOrCreate(conf=conf)

# 입력 파일 로드
text_file = sc.textFile("input.txt")

# 단어 분리 및 카운트
word_counts = (text_file.flatMap(lambda line: line.split())
                       .map(lambda word: (word, 1))
                       .reduceByKey(lambda a, b: a + b))

# 결과 출력
for word, count in word_counts.collect():
    print(f"{word}: {count}")

# SparkContext 종료
sc.stop()
