class Comment{
  final String text;
  final String author;
  final dynamic attachments;
  final bool isMy;
  Comment({required this.text,required this.author,required this.attachments,this.isMy=false});
}