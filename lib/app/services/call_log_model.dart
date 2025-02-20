class CallLogModel {
  final String number;
  final CallType callType;
  final int timestamp;
  final int duration;
  final String name;
  final String simDisplayName;
  final String phoneAccountId;
  final String geocodedLocation;
  final String voicemailUri;
  final int isRead;
  final int isNew;
  final String postDialDigits;
  final String accountComponentName;
  final String accountId;
  final int features;
  final int dataUsage;
  final String transcription;

  CallLogModel({
    required this.number,
    required this.callType,
    required this.timestamp,
    required this.duration,
    required this.name,
    required this.simDisplayName,
    required this.phoneAccountId,
    required this.geocodedLocation,
    required this.voicemailUri,
    required this.isRead,
    required this.isNew,
    required this.postDialDigits,
    required this.accountComponentName,
    required this.accountId,
    required this.features,
    required this.dataUsage,
    required this.transcription,
  });

  /// Factory method to create a CallLogModel from a Map (JSON)
  factory CallLogModel.fromMap(Map<String, dynamic> map) {
    return CallLogModel(
      number: map['number'] ?? 'Unknown',
      callType: getCallType(map['callType']),
      timestamp: map['timestamp'] ?? 0,
      duration: map['duration'] ?? 0,
      name: map['name'] ?? 'Unknown',
      simDisplayName: map['simDisplayName'] ?? 'Unknown SIM',
      phoneAccountId: map['phoneAccountId'] ?? '',
      geocodedLocation: map['geocodedLocation'] ?? '',
      voicemailUri: map['voicemailUri'] ?? '',
      isRead: map['isRead'] ?? 0,
      isNew: map['isNew'] ?? 0,
      postDialDigits: map['postDialDigits'] ?? '',
      accountComponentName: map['accountComponentName'] ?? '',
      accountId: map['accountId'] ?? '',
      features: map['features'] ?? 0,
      dataUsage: map['dataUsage'] ?? 0,
      transcription: map['transcription'] ?? '',
    );
  }

  /// Convert CallLogModel to a Map (useful for debugging or sending data)
  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'callType': callType,
      'timestamp': timestamp,
      'duration': duration,
      'name': name,
      'simDisplayName': simDisplayName,
      'phoneAccountId': phoneAccountId,
      'geocodedLocation': geocodedLocation,
      'voicemailUri': voicemailUri,
      'isRead': isRead,
      'isNew': isNew,
      'postDialDigits': postDialDigits,
      'accountComponentName': accountComponentName,
      'accountId': accountId,
      'features': features,
      'dataUsage': dataUsage,
      'transcription': transcription,
    };
  }

  @override
  String toString() {
    return 'CallLogModel(number: $number, callType: $callType, timestamp: $timestamp, '
        'duration: $duration, name: $name, simDisplayName: $simDisplayName, '
        'phoneAccountId: $phoneAccountId, geocodedLocation: $geocodedLocation, '
        'voicemailUri: $voicemailUri, isRead: $isRead, isNew: $isNew, '
        'postDialDigits: $postDialDigits, accountComponentName: $accountComponentName, '
        'accountId: $accountId, features: $features, dataUsage: $dataUsage, '
        'transcription: $transcription)';
  }
}

enum CallType {
  /// incoming call
  incoming,

  /// outgoing call
  outgoing,

  /// missed incoming call
  missed,

  /// voicemail call
  voiceMail,

  /// rejected incoming call
  rejected,

  /// blocked incoming call
  blocked,

  /// todo comment
  answeredExternally,

  /// unknown type of call
  unknown,

  /// wifi incoming
  wifiIncoming,

  ///wifi outgoing
  wifiOutgoing,
}

///method for returning the callType
CallType getCallType(int n) {
  if (n == 100) {
    //return the wifi outgoing call
    return CallType.wifiOutgoing;
  } else if (n == 101) {
    //return wifiIncoming call
    return CallType.wifiIncoming;
  } else if (n >= 1 && n <= 8) {
    return CallType.values[n - 1];
  } else {
    return CallType.unknown;
  }
}
