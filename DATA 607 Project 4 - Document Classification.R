
# Clear the console
cat("\014")

# Check if the package is installed. If not, install the package
if(!require('RTextTools')) {
  install.packages('RTextTools')
  library(RTextTools)
}

if(!require('tm')) {
  install.packages('tm')
  library(tm)
}

if(!require('wordcloud')) {
  install.packages('wordcloud')
  library(wordcloud)
}

if(!require('e1071')) {
  install.packages('e1071')
  library(e1071)
}

# The following website is used as a reference to complete this assignment
# http://www3.nd.edu/~steve/computing_with_data/20_text_mining/text_mining_example.html#

# Create Ham Dataframe
ham_dir="D:/Data/easy_ham"
hamFileNames = list.files(ham_dir)

# List of docs
ham_docs_list <- NA
for(i in 1:length(hamFileNames))
{
  filepath<-paste0(ham_dir, "/", hamFileNames[1])  
  text <-readLines(filepath)
  list1<- list(paste(text, collapse="\n"))
  ham_docs_list = c(ham_docs_list,list1)
  
}

# ham data frame
hamDF <-as.data.frame(unlist(ham_docs_list),stringsAsFactors = FALSE)
hamDF$type <- "ham"
colnames(hamDF) <- c("text","type")

# Create Spam Dataframe
spam_dir="D:/Data/spam"
spamFileNames = list.files(spam_dir)

spam_docs_list <- NA
for(i in 1:length(spamFileNames))
{
  filepath<-paste0(spam_dir, "/", spamFileNames[1])  
  text <-readLines(filepath)
  list1<- list(paste(text, collapse="\n"))
  spam_docs_list = c(spam_docs_list,list1)
  
}

spamDF <-as.data.frame(unlist(spam_docs_list),stringsAsFactors = FALSE)
spamDF$type <- "spam"
colnames(spamDF) <- c("text","type")


# creating combined data frame of spam and ham
spam_ham_df <- rbind(hamDF, spamDF)

# Create email Corpus from email text Vector (tm package)
emailCorpus <- Corpus(VectorSource(spam_ham_df$text))
cleanCorpus <- tm_map(emailCorpus, removeNumbers)
cleanCorpus <- tm_map(cleanCorpus, removePunctuation)
cleanCorpus <- tm_map(cleanCorpus, removeWords, stopwords())
cleanCorpus <- tm_map(cleanCorpus, stripWhitespace)


# Create documen-term matrix for ham and spam emails
# documenterm matrix is the mathematical maxtrix that describes the frequency of terms that occurs in a collection of documents
email_dtm <- DocumentTermMatrix(cleanCorpus)

# spam word cloud
spam_indices <- which(spam_ham_df$type == "spam")
suppressWarnings(wordcloud(cleanCorpus[spam_indices], min.freq=40))


# ham word cloud
ham_indices <- which(spam_ham_df$type == "ham")
suppressWarnings(wordcloud(cleanCorpus[ham_indices], min.freq=50))

# Model to assess spam and ham

# sample 70% data traning and 30 % for prediction

sample_size <- floor(0.70 * nrow(spam_ham_df))

# set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(spam_ham_df)), size = sample_size)

train_spam_ham <- spam_ham_df[train_ind, ]
test_spam_ham <- spam_ham_df[-train_ind, ]

# count of spam and ham in train data set
spam<-subset(train_spam_ham,train_spam_ham$type == "spam")
ham<-subset(train_spam_ham,train_spam_ham$type == "ham")


# Create corpus for training and test data
train_email_corpus <- Corpus(VectorSource(train_spam_ham$text))
test_email_corpus <- Corpus(VectorSource(test_spam_ham$text))

train_clean_corpus <- tm_map(train_email_corpus ,removeNumbers)
test_clean_corpus <- tm_map(test_email_corpus, removeNumbers)

train_clean_corpus <- tm_map(train_clean_corpus, removePunctuation)
test_clean_corpus <- tm_map(test_clean_corpus, removePunctuation)

train_clean_corpus <- tm_map(train_clean_corpus, removeWords, stopwords())
test_clean_corpus  <- tm_map(test_clean_corpus, removeWords, stopwords())

train_clean_corpus<- tm_map(train_clean_corpus, stripWhitespace)
test_clean_corpus<- tm_map(test_clean_corpus, stripWhitespace)

train_email_dtm <- DocumentTermMatrix(train_clean_corpus)
test_email_dtm <- DocumentTermMatrix(test_clean_corpus)

# count function
convert_count <- function(x) {
  y <- ifelse(x > 0, 1,0)
  y <- factor(y, levels=c(0,1), labels=c("No", "Yes"))
  y
}

train_sms <- apply(train_email_dtm, 2, convert_count)
test_sms <- apply(test_email_dtm, 2, convert_count)

# classification of email
classifier <- naiveBayes(train_sms, factor(train_spam_ham$type))

test_pred <- predict(classifier, newdata=test_sms)

table(test_pred, test_spam_ham$type)


