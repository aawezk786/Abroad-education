

import 'package:image_picker/image_picker.dart';
class Opportunity{
  final int id;
  final String title;
  final String opportunityType;
  final String fundingType;
  final String region;
  final String opportunityTypeEnum;
  final String fundingTypeEnum;
  final String regionEnum;
  final String image;
  final String deadline;
  final String deadlineString;
  final String timeLeft;
  final String description;
  final String benefit;
  final String eligibility;
  final String applicationProcess;
  final String other;
  final String url;
  final String applyUrl;
  final bool featured;

  final PickedFile imageFile;

  Opportunity({this.id,this.title,this.opportunityType,this.fundingType,this.region,this.opportunityTypeEnum,this.fundingTypeEnum,this.regionEnum,this.image,this.deadline,
                this.deadlineString,this.timeLeft,this.description,this.benefit,this.eligibility,this.applicationProcess,this.other,this.url,this.applyUrl,this.featured,this.imageFile});

  factory Opportunity.fromJson(Map<String, dynamic>json){
    return Opportunity(
      id: json['id'],
      title: json['title'],
      opportunityType: json['opportunityType'],
      fundingType: json['fundingType'],
      region: json['region'],
      opportunityTypeEnum: json['opportunityTypeEnum'],
      fundingTypeEnum: json['fundingTypeEnum'],
      regionEnum: json['regionEnum'],
      image: json['image'],
      deadline: json['deadline'],
      deadlineString: json['deadlineString'],
      timeLeft: json['timeLeft'],
      description: json['description'],
      benefit: json['benefit'],
      eligibility: json['eligibility'],
      applicationProcess: json['application_process'],
      other: json['other'],
      url: json['url'],
      applyUrl: json['apply_url'],
      featured: json['featured']
    );
  }


  Map<String, dynamic> toJson() => {
    'title' : title,
    'opportunityType' : opportunityType,
    'fundingType' : fundingType,
    'region' : region,
    'imageFile' : imageFile,
    'deadline' : deadline,
    'description' : description,
    'benefit' : benefit,
    'eligibility' : eligibility,
    'application_process' : applicationProcess,
    'other' : other,
    'url' : url,
    'apply_url' : applyUrl,
  };
}