// League model
class League {
  final int leagueId;
  final String docRef;
  final String leagueType;
  final String leagueName;
  final List<String> leaguePresidents;
  final List<String> leagueAdmins;
  final LeagueAddress leagueAddress;
  final String leagueEmail;
  final String leaguePhone;
  final List<BallField> leagueBallFields;

  League({
    required this.leagueId,
    required this.docRef,
    required this.leagueType,
    required this.leagueName,
    required this.leaguePresidents,
    required this.leagueAdmins,
    required this.leagueAddress,
    required this.leagueEmail,
    required this.leaguePhone,
    required this.leagueBallFields,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      leagueId: json['leagueId'],
      docRef: json['docRef'],
      leagueType: json['leagueType'],
      leagueName: json['leagueName'],
      leaguePresidents: List<String>.from(json['leaguePresidents']),
      leagueAdmins: List<String>.from(json['leagueAdmins']),
      leagueAddress: LeagueAddress.fromJson(json['leagueAddress']),
      leagueEmail: json['leagueEmail'],
      leaguePhone: json['leaguePhone'],
      leagueBallFields: (json['leagueBallFields'] as List).map((ballFieldJson) => BallField.fromJson(ballFieldJson)).toList(),
    );
  }
}

// LeagueAddress model (nested within League)
class LeagueAddress {
  final String address;
  final String address2;
  final String city;
  final String state;
  final String zip;
  final String country;

  LeagueAddress({
    required this.address,
    required this.address2,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory LeagueAddress.fromJson(Map<String, dynamic> json) {
    return LeagueAddress(
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }
}

// Division model
class Division {
  final String divisionId; // Assuming divisionId will always be a string
  final String? divisionName;
  final String? divisionPresident;
  final List<String>? divisionAdmins;
  final DivisionAddress? divisionAddress;
  final String? divisionEmail;
  final String? divisionPhone;
  final String leagueId;
  final DateTime seasonStartDate;
  final DateTime seasonEndDate;
  final String description;
  final Game scheduledGames;

  Division({
    required this.divisionId,
    this.divisionName,
    this.divisionPresident,
    this.divisionAdmins,
    this.divisionAddress,
    this.divisionEmail,
    this.divisionPhone,
    required this.leagueId,
    required this.seasonStartDate,
    required this.seasonEndDate,
    required this.description,
    required this.scheduledGames,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      divisionId: json['divisionId'].toString(),
      divisionName: json['divisionName'],
      divisionPresident: json['divisionPresident'],
      divisionAdmins: json['divisionAdmins']?.cast<String>(),
      divisionAddress: json['divisionAddress'] != null ? DivisionAddress.fromJson(json['divisionAddress']) : null,
      divisionEmail: json['divisionEmail'],
      divisionPhone: json['divisionPhone'],
      leagueId: json['leagueId'],
      seasonStartDate: DateTime.parse(json['seasonStartDate']),
      seasonEndDate: DateTime.parse(json['seasonEndDate']),
      description: json['description'],
      scheduledGames: Game.fromJson(json['scheduledGames']),
    );
  }
}

// DivisionAddress model (nested within Division)
class DivisionAddress {
  final String address;
  final String address2;
  final String city;
  final String state;
  final String zip;
  final String country;

  DivisionAddress({
    required this.address,
    required this.address2,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory DivisionAddress.fromJson(Map<String, dynamic> json) {
    return DivisionAddress(
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }
}

// GameType enum
enum GameType {
  preseason,
  regular,
  postseason,
  allstar,
  tournament,
  scrimmage,
  friendly,
  practice,
  other,
}

// GameStatus enum
enum GameStatus {
  scheduled,
  inProgress,
  completed,
  forfeit,
  cancelled,
}

// Game model
class Game {
  final String docRef;
  final String gameId;
  final DateTime gameDate;
  final bool gameStarted;
  final bool gameOfficial;
  final bool? gameEnded;
  final String gameType; // You might want to use the GameType enum here
  final List<FinalScore> finalScore;
  final String divisionId;
  final TeamInfo homeTeam;
  final LineUp lineup;
  final TeamInfo visitorTeam;
  final BallField gameLocation;
  final String? gameSessionId;
  final DateTime gameStartTime;
  final List<GameEvent> gameEvents;
  final List<GameStats> gameStats;
  final GameStatus gameStatus; // You might want to use the GameStatus enum here

  Game({
    required this.docRef,
    required this.gameId,
    required this.gameDate,
    required this.gameStarted,
    required this.gameOfficial,
    this.gameEnded,
    required this.gameType,
    required this.finalScore,
    required this.divisionId,
    required this.homeTeam,
    required this.lineup,
    required this.visitorTeam,
    required this.gameLocation,
    this.gameSessionId,
    required this.gameStartTime,
    required this.gameEvents,
    required this.gameStats,
    required this.gameStatus,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      docRef: json['docRef'],
      gameId: json['gameId'],
      gameDate: DateTime.parse(json['gameDate']),
      gameStarted: json['gameStarted'],
      gameOfficial: json['gameOfficial'],
      gameEnded: json['gameEnded'],
      gameType: json['gameType'],
      finalScore: (json['finalScore'] as List).map((scoreJson) => FinalScore.fromJson(scoreJson)).toList(),
      divisionId: json['divisionId'],
      homeTeam: TeamInfo.fromJson(json['homeTeam']),
      lineup: LineUp.fromJson(json['lineup']),
      visitorTeam: TeamInfo.fromJson(json['visitorTeam']),
      gameLocation: BallField.fromJson(json['gameLocation']),
      gameSessionId: json['gameSessionId'],
      gameStartTime: DateTime.parse(json['gameStartTime']),
      gameEvents: (json['gameEvents'] as List).map((eventJson) => GameEvent.fromJson(eventJson)).toList(),
      gameStats: (json['gameStats'] as List).map((statsJson) => GameStats.fromJson(statsJson)).toList(),
      gameStatus: _gameStatusFromString(json['gameStatus']),
    );
  }

  // Helper function to convert string to GameStatus enum
  static GameStatus _gameStatusFromString(String statusString) {
    return GameStatus.values.firstWhere(
          (e) => e.toString().split('.').last == statusString,
      orElse: () => GameStatus.scheduled,
    );
  }
}

// FinalScore model (nested within Game)
class FinalScore {
  final String teamId;
  final int score;

  FinalScore({
    required this.teamId,
    required this.score,
  });

  factory FinalScore.fromJson(Map<String, dynamic> json) {
    return FinalScore(
      teamId: json['teamId'],
      score: json['score'],
    );
  }
}

// TeamInfo model (nested within Game)
class TeamInfo {
  final String teamid;
  final String name;
  final String manager;
  final List<dynamic>? teamAdmins;
  final List<dynamic>? adminLoggedIn;
  final String? probableStarter;
  final String docRef;
  final String? gameSessionId;

  TeamInfo({
    required this.teamid,
    required this.name,
    required this.manager,
    this.teamAdmins,
    this.adminLoggedIn,
    this.probableStarter,
    required this.docRef,
    this.gameSessionId,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      teamid: json['teamid'],
      name: json['name'],
      manager: json['manager'],
      teamAdmins: json['teamAdmins'],
      adminLoggedIn: json['adminLoggedIn'],
      probableStarter: json['probableStarter'],
      docRef: json['docRef'],
      gameSessionId: json['gameSessionId'],
    );
  }
}

// LineUp model (nested within Game)
class LineUp {
  final List<PlayerPosition> homeTeam;
  final List<PlayerPosition> visitorTeam;

  LineUp({
    required this.homeTeam,
    required this.visitorTeam,
  });

  factory LineUp.fromJson(Map<String, dynamic> json) {
    return LineUp(
      homeTeam: (json['homeTeam'] as List).map((playerJson) => PlayerPosition.fromJson(playerJson)).toList(),
      visitorTeam: (json['visitorTeam'] as List).map((playerJson) => PlayerPosition.fromJson(playerJson)).toList(),
    );
  }
}

// PlayerPosition model (nested within LineUp)
class PlayerPosition {
  final String playerId;
  final List<String> position;

  PlayerPosition({
    required this.playerId,
    required this.position,
  });

  factory PlayerPosition.fromJson(Map<String, dynamic> json) {
    return PlayerPosition(
      playerId: json['playerId'],
      position: List<String>.from(json['position']),
    );
  }
}

// GameEvent model
class GameEvent {
  final DateTime timestamp;
  final String eventType;
  final int inning;
  final String halfInning;
  final String batterId; // Assuming batterId will always be a string
  final String pitcherId; // Assuming pitcherId will always be a string
  final String outcome;

  GameEvent({
    required this.timestamp,
    required this.eventType,
    required this.inning,
    required this.halfInning,
    required this.batterId,
    required this.pitcherId,
    required this.outcome,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      timestamp: DateTime.parse(json['timestamp']),
      eventType: json['eventType'],
      inning: json['inning'],
      halfInning: json['halfInning'],
      batterId: json['batterId'].toString(),
      pitcherId: json['pitcherId'].toString(),
      outcome: json['outcome'],
    );
  }
}

// BallField model
class BallField {
  final String name;
  final String address;
  final String city;
  final String state;
  final String? zip;
  final String? geolocation;
  final num? latitude;
  final num? longitude;

  BallField({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    this.zip,
    this.geolocation,
    this.latitude,
    this.longitude,
  });

  factory BallField.fromJson(Map<String, dynamic> json) {
    return BallField(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      geolocation: json['geolocation'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

// Team model
class Team {
  final String? id;
  final String? teamid;
  final String docRef;
  final String? divisionId;
  final List<String> teamAdmin;
  final String age;
  final String name;
  final String userName;
  final String logoUrl;
  final String? description;
  final String manager;
  final BallField? homeField;
  final String country;
  final String state;
  final String city;
  final String zip;
  final String? phone;
  final String? email;
  final String? website;
  final bool travelTeam;
  final List<Follower>? followers;
  final List<Following>? following;
  final num? longitude;
  final num? latitude;
  final List<TeamScheduledGame> teamScheduledGames;
  final List<Player>? teamPlayers;
  final String userId;
  final String uniqueId;

  Team({
    this.id,
    this.teamid,
    required this.docRef,
    this.divisionId,
    required this.teamAdmin,
    required this.age,
    required this.name,
    required this.userName,
    required this.logoUrl,
    this.description,
    required this.manager,
    this.homeField,
    required this.country,
    required this.state,
    required this.city,
    required this.zip,
    this.phone,
    this.email,
    this.website,
    required this.travelTeam,
    this.followers,
    this.following,
    this.longitude,
    this.latitude,
    required this.teamScheduledGames,
    this.teamPlayers,
    required this.userId,
    required this.uniqueId,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      teamid: json['teamid'],
      docRef: json['docRef'],
      divisionId: json['divisionId'],
      teamAdmin: List<String>.from(json['teamAdmin']),
      age: json['age'],
      name: json['name'],
      userName: json['userName'],
      logoUrl: json['logoUrl'],
      description: json['description'],
      manager: json['manager'],
      homeField: json['homeField'] != null ? BallField.fromJson(json['homeField']) : null,
      country: json['country'],
      state: json['state'],
      city: json['city'],
      zip: json['zip'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      travelTeam: json['travelTeam'],
      followers: (json['followers'] as List?)?.map((followerJson) => Follower.fromJson(followerJson)).toList(),
      following: (json['following'] as List?)?.map((followingJson) => Following.fromJson(followingJson)).toList(),
      longitude: json['longitude'],
      latitude: json['latitude'],
      teamScheduledGames: (json['teamScheduledGames'] as List).map((gameJson) => TeamScheduledGame.fromJson(gameJson)).toList(),
      teamPlayers: (json['teamPlayers'] as List?)?.map((playerJson) => Player.fromJson(playerJson)).toList(),
      userId: json['userId'],
      uniqueId: json['uniqueId'],
    );
  }
}

// TeamScheduledGame model (nested within Team)
class TeamScheduledGame {
  final String gameId;
  final DateTime gameDate;
  final bool gamePlayed;
  final bool gameStarted;
  final String homeTeam;
  final String visitorTeam;
  final BallField gameLocation;
  final DateTime gameStartTime; // Assuming gameStartTime will be a DateTime object

  TeamScheduledGame({
    required this.gameId,
    required this.gameDate,
    required this.gamePlayed,
    required this.gameStarted,
    required this.homeTeam,
    required this.visitorTeam,
    required this.gameLocation,
    required this.gameStartTime,
  });

  factory TeamScheduledGame.fromJson(Map<String, dynamic> json) {
    return TeamScheduledGame(
      gameId: json['gameId'],
      gameDate: DateTime.parse(json['gameDate']),
      gamePlayed: json['gamePlayed'],
      gameStarted: json['gameStarted'],
      homeTeam: json['homeTeam'],
      visitorTeam: json['visitorTeam'],
      gameLocation: BallField.fromJson(json['gameLocation']),
      gameStartTime: DateTime.parse(json['gameStartTime']), // Assuming gameStartTime is a parsable date string
    );
  }
}

// Player model
class Player {
  final String? id;
  final String? userId;
  final int? playerId;
  final String? firstName;
  final String? lastName;
  final bool? activePlayer;
  final String? ageGroup;
  final List<String>? positions;
  final String throws;
  final String bats;
  final String gender;
  final String? geohash;
  final String? height;
  final String? weight;
  final String? country;
  final String? state;
  final String? city;
  final String? docRef;
  final num? latitude;
  final num? longitude;
  final List<dynamic>? sports;
  final DateTime? createdAt;
  final List<String>? skillLevel;
  final int? gamesPerWeek;
  final List<String>? transportation;
  final List<GameStats>? playerStats;
  final List<String>? teamsPlayed;
  final List<Team>? teams;
  final String? photoURL;

  Player({
    this.id,
    this.userId,
    this.playerId,
    this.firstName,
    this.lastName,
    this.activePlayer,
    this.ageGroup,
    this.positions,
    required this.throws,
    required this.bats,
    required this.gender,
    this.geohash,
    this.height,
    this.weight,
    this.country,
    this.state,
    this.city,
    this.docRef,
    this.latitude,
    this.longitude,
    this.sports,
    this.createdAt,
    this.skillLevel,
    this.gamesPerWeek,
    this.transportation,
    this.playerStats,
    this.teamsPlayed,
    this.teams,
    this.photoURL,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      userId: json['userId'],
      playerId: json['playerId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      activePlayer: json['activePlayer'],
      ageGroup: json['ageGroup'],
      positions: json['positions']?.cast<String>(),
      throws: json['throws'],
      bats: json['bats'],
      gender: json['gender'],
      geohash: json['geohash'],
      height: json['height'],
      weight: json['weight'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      docRef: json['docRef'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      sports: json['sports'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      skillLevel: json['skillLevel']?.cast<String>(),
      gamesPerWeek: json['gamesPerWeek'],
      transportation: json['transportation']?.cast<String>(),
      playerStats: (json['playerStats'] as List?)?.map((statsJson) => GameStats.fromJson(statsJson)).toList(),
      teamsPlayed: json['teamsPlayed']?.cast<String>(),
      teams: (json['teams'] as List?)?.map((teamJson) => Team.fromJson(teamJson)).toList(),
      photoURL: json['photoURL'],
    );
  }
}

// Sport model
class Sport {
  final String name;
  final List<String> playerPosition;

  Sport({
    required this.name,
    required this.playerPosition,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'],
      playerPosition: List<String>.from(json['playerPosition']),
    );
  }
}

// YouthPlayer model
class YouthPlayer {
  final String? id;
  final String? userId;
  final String? playerId;
  final bool? activePlayer;
  final String firstName;
  final String? lastName;
  final String? gender;
  final String geohash;
  final String? sport;
  final String? height;
  final String? weight;
  final String parentId;
  final String throws;
  final String bats;
  final int gamesPerWeek;
  final List<String> playerPosition;
  final String transportation;

  YouthPlayer({
    this.id,
    this.userId,
    this.playerId,
    this.activePlayer,
    required this.firstName,
    this.lastName,
    this.gender,
    required this.geohash,
    this.sport,
    this.height,
    this.weight,
    required this.parentId,
    required this.throws,
    required this.bats,
    required this.gamesPerWeek,
    required this.playerPosition,
    required this.transportation,
  });

  factory YouthPlayer.fromJson(Map<String, dynamic> json) {
    return YouthPlayer(
      id: json['id'],
      userId: json['userId'],
      playerId: json['playerId'],
      activePlayer: json['activePlayer'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      geohash: json['geohash'],
      sport: json['sport'],
      height: json['height'],
      weight: json['weight'],
      parentId: json['parentId'],
      throws: json['throws'],
      bats: json['bats'],
      gamesPerWeek: json['gamesPerWeek'],
      playerPosition: List<String>.from(json['playerPosition']),
      transportation: json['transportation'],
    );
  }
}

// GameStats model
class GameStats {
  final String gameId;
  final int gamePlayed;
  final int currentInning;
  final int currentOuts;
  final List<InningDetails> inningDetails;
  final List<LineUp> fieldLineUp;
  final bool gameStarted;
  final List<BattingStats>? battingStats;
  final List<PitchingStats>? pitchingStats;
  final List<OnBases>? onBaseStats;
  final Innings innings;
  final List<dynamic>? gameEvents;

  GameStats({
    required this.gameId,
    required this.gamePlayed,
    required this.currentInning,
    required this.currentOuts,
    required this.inningDetails,
    required this.fieldLineUp,
    required this.gameStarted,
    this.battingStats,
    this.pitchingStats,
    this.onBaseStats,
    required this.innings,
    this.gameEvents,
  });

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      gameId: json['gameId'],
      gamePlayed: json['gamePlayed'],
      currentInning: json['currentInning'],
      currentOuts: json['currentOuts'],
      inningDetails: (json['inningDetails'] as List).map((inningJson) => InningDetails.fromJson(inningJson)).toList(),
      fieldLineUp: (json['fieldLineUp'] as List).map((lineUpJson) => LineUp.fromJson(lineUpJson)).toList(),
      gameStarted: json['gameStarted'],
      battingStats: (json['battingStats'] as List?)?.map((statsJson) => BattingStats.fromJson(statsJson)).toList(),
      pitchingStats: (json['pitchingStats'] as List?)?.map((statsJson) => PitchingStats.fromJson(statsJson)).toList(),
      onBaseStats: (json['onBaseStats'] as List?)?.map((statsJson) => OnBases.fromJson(statsJson)).toList(),
      innings: Innings.fromJson(json['innings']),
      gameEvents: json['gameEvents'],
    );
  }
}

// Innings model (nested within GameStats)
class Innings {
  final Map<int, InningDetails> innings;

  Innings({required this.innings});

  factory Innings.fromJson(Map<String, dynamic> json) {
    Map<int, InningDetails> inningsMap = {};
    json.forEach((key, value) {
      final inningNumber = int.parse(key);
      inningsMap[inningNumber] = InningDetails.fromJson(value);
    });
    return Innings(innings: inningsMap);
  }
}

// InningDetails model
class InningDetails {
  final String halfInning;
  final List<Play> plays;
  final int outs;
  final int errors;
  final int hits;
  final int runsScored;

  InningDetails({
    required this.halfInning,
    required this.plays,
    required this.outs,
    required this.errors,
    required this.hits,
    required this.runsScored,
  });

  factory InningDetails.fromJson(Map<String, dynamic> json) {
    return InningDetails(
      halfInning: json['halfInning'],
      plays: (json['plays'] as List).map((playJson) => Play.fromJson(playJson)).toList(),
      outs: json['outs'],
      errors: json['errors'],
      hits: json['hits'],
      runsScored: json['runsScored'],
    );
  }
}

// LineUp model (used in Game and GameStats)
// ... (same as before)

// BattingStats model
class BattingStats {
  final int? atBats;
  final int? bunt;
  final int? single;
  final int? double;
  final int? triple;
  final int? homerun;
  final int? walk;
  final int? fielderChoice;
  final int? reachedOnError;
  final int? strikeOut;
  final int? sacrificeFly;
  final int? swingStrikeOut;
  final int? hitByPitch;
  final int? runsBattedIn;
  final int? runnersStranded;
  final String? pitcherId;
  final String? playerId;
  final List<PutOut> outType;

  BattingStats({
    this.atBats,
    this.bunt,
    this.single,
    this.double,
    this.triple,
    this.homerun,
    this.walk,
    this.fielderChoice,
    this.reachedOnError,
    this.strikeOut,
    this.sacrificeFly,
    this.swingStrikeOut,
    this.hitByPitch,
    this.runsBattedIn,
    this.runnersStranded,
    this.pitcherId,
    this.playerId,
    required this.outType,
  });

  factory BattingStats.fromJson(Map<String, dynamic> json) {
    return BattingStats(
      atBats: json['atBats'],
      bunt: json['bunt'],
      single: json['single'],
      double: json['double'],
      triple: json['triple'],
      homerun: json['homerun'],
      walk: json['walk'],
      fielderChoice: json['fielderChoice'],
      reachedOnError: json['reachedOnError'],
      strikeOut: json['strikeOut'],
      sacrificeFly: json['sacrificeFly'],
      swingStrikeOut: json['swingStrikeOut'],
      hitByPitch: json['hitByPitch'],
      runsBattedIn: json['runsBattedIn'],
      runnersStranded: json['runnersStranded'],
      pitcherId: json['pitcherId'],
      playerId: json['playerId'],
      outType: (json['outType'] as List).map((outJson) => PutOut.fromJson(outJson)).toList(),
    );
  }
}

class OnBases {
  final int? caughtStealing;
  final int? stolenBase;
  final int? scoredOnHit;
  final int? scoredOnError;
  final int? scoredOnWalk;
  final int? advanceOnWalk;
  final int? advanceOnOut;
  final int? advancedOnHit;
  final int? runScored;
  final BasesTouched? basesTouched;
  final int? pickedOffBase;

  OnBases({
    this.caughtStealing,
    this.stolenBase,
    this.scoredOnHit,
    this.scoredOnError,
    this.scoredOnWalk,
    this.advanceOnWalk,
    this.advanceOnOut,
    this.advancedOnHit,
    this.runScored,
    this.basesTouched,
    this.pickedOffBase,
  });

  factory OnBases.fromJson(Map<String, dynamic> json) {
    return OnBases(
      caughtStealing: json['caughtStealing'] as int?,
      stolenBase: json['stolenBase'] as int?,
      scoredOnHit: json['scoredOnHit'] as int?,
      scoredOnError: json['scoredOnError'] as int?,
      scoredOnWalk: json['scoredOnWalk'] as int?,
      advanceOnWalk: json['advanceOnWalk'] as int?,
      advanceOnOut: json['advanceOnOut'] as int?,
      advancedOnHit: json['advancedOnHit'] as int?,
      runScored: json['runScored'] as int?,
      basesTouched: json['basesTouched'] != null
          ? BasesTouched.fromJson(json['basesTouched'])
          : null,
      pickedOffBase: json['pickedOffBase'] as int?,
    );
  }
}

class BasesTouched {
  final bool first;
  final bool second;
  final bool third;
  final bool home;

  BasesTouched({
    required this.first,
    required this.second,
    required this.third,
    required this.home,
  });

  factory BasesTouched.fromJson(Map<String, dynamic> json) {
    return BasesTouched(
      first: json['first'] as bool,
      second: json['second'] as bool,
      third: json['third'] as bool,
      home: json['home'] as bool,
    );
  }
}

