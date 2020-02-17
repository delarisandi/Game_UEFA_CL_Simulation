program Tubes;
uses crt,sysutils,Windows;

 label
  Drawing,StartGame,RestartGame,ChangeTeam,
  Menu_GroupStage,Play_GroupStage,
  Draw_Round16,Menu_Draw_Round16,Menu_Round16,Play_Round16,
  Draw_QuarterFinal,Menu_Draw_QuarterFinal,Menu_QuarterFinal,Play_QuarterFinal,
  Draw_Semifinal,Menu_Draw_Semifinal,Menu_Semifinal,Play_Semifinal,
  Menu_Final,Play_Final,Menu_End,ExitGame;

 type TeamData =
  record
   Team_ID:integer;
   Team_Name:string;
   Club_Name:string;
   Country:string;
   City:string;
   Manager:string;
   Home_Stadium:string;
   Titles:integer;
   Group:char;
   Played:integer;
   Wins:integer;
   Draws:integer;
   Losses:integer;
   Goals_Scored:integer;
   Goals_Conceded:integer;
   Cleansheet:integer;   
  end;

 type MyMatch =
  record
   Match_ID:integer;
   Status:string;
  end;

 type ParticipantData =
  record
   MyTeam_ID:integer;
   MyTeam_Group:integer;
   MyTeam_Match:array [1..13] of MyMatch;
   MyTeam_Qualify:boolean;
   ParticipantArray:array [1..32] of integer;
  end;

 type Standings =
  record
   Team_ID:integer;
   Group:char;
   Played:integer;
   Win:integer;
   Draw:integer;
   Loss:integer;
   Goals_Scored:integer;
   Goals_Conceded:integer;
   Goals_Difference:integer;
   Points:integer;
  end;

 type MatchData =
  record
   Phase:string;
   Matchday:integer;
   Home_Team:integer;
   Home_Code:integer;
   Home_Score:integer;   
   Home_Agg:integer;     
   Home_Pen:integer; 
   Away_Team:integer;
   Away_Code:integer;
   Away_Score:integer;
   Away_Agg:integer;
   Away_Pen:integer;   
   Venue:string;
   Status:string;
  end;

 type StatsData =
  record
   Most_Wins:integer;
   Most_Draws:integer;
   Most_Losses:integer;
   Best_Attack:integer;
   Best_Defence:integer;
   Poor_Attack:integer;
   Poor_Defence:integer;
   Most_Cleansheet:integer;
  end;


 var 
  Match_Code,Matchday,Menu,Final_Host,Champions,temp:integer;
  Locator:string;
  Participant:ParticipantData;
  Stats:StatsData;
  Club:array [1..64] of TeamData;
  Pot:array [1..32] of integer;   
  Group:array [1..8,1..4] of Standings;
  GroupRankings:array [1..8,1..4] of integer;  
  Match:array [1..8,1..12] of MatchData;
  KnockOutMatch:array [1..29] of MatchData;
             

 procedure AssignTeamData;
  var
   id:integer;
  begin
   for id:=1 to 64 do
    begin
     Club[id].Team_ID:=id;
    end;

   Club[1].Team_Name:='Arsenal';
   Club[1].Country:='England';
   Club[1].Manager:='Unai Emery';
   Club[1].Home_Stadium:='Emirates Stadium';
   Club[1].Club_Name:='Arsenal Football Club';
   Club[1].City:='London';
   Club[1].Titles:=0;   

   Club[2].Team_Name:='Chelsea';
   Club[2].Country:='England';
   Club[2].Manager:='Maurizio Sarri';
   Club[2].Home_Stadium:='Stamford Bridge';
   Club[2].Club_Name:='Chelsea Football Club';
   Club[2].City:='London';
   Club[2].Titles:=1;       

   Club[3].Team_Name:='Liverpool';
   Club[3].Country:='England';
   Club[3].Manager:='Jurgen Klopp';
   Club[3].Home_Stadium:='Anfield';
   Club[3].Club_Name:='Liverpool Football Club';
   Club[3].City:='Liverpool';
   Club[3].Titles:=5;    


   Club[4].Team_Name:='Manchester City';
   Club[4].Country:='England';
   Club[4].Manager:='Pep Guardiola';
   Club[4].Home_Stadium:='Etihad Stadium';
   Club[4].Club_Name:='Manchester City Football Club';
   Club[4].City:='Manchester';
   Club[4].Titles:=0;    

   Club[5].Team_Name:='Manchester United';
   Club[5].Country:='England';
   Club[5].Manager:='Jose Mourinho';
   Club[5].Home_Stadium:='Old Trafford';
   Club[5].Club_Name:='Manchester United Football Club';
   Club[5].City:='Manchester';
   Club[5].Titles:=3;    

   Club[6].Team_Name:='Tottenham Hotspurs';
   Club[6].Country:='England';
   Club[6].Manager:='Mauricio Pochettino';
   Club[6].Home_Stadium:='Tottenham Hotspurs Stadium';
   Club[6].Club_Name:='Tottenham Hotspurs Football Club';
   Club[6].City:='London';
   Club[6].Titles:=0;    

   Club[7].Team_Name:='Leicester City';
   Club[7].Country:='England';
   Club[7].Manager:='Claude Puel';
   Club[7].Home_Stadium:='King Power Stadium';
   Club[7].Club_Name:='Leicester City Football Club';
   Club[7].City:='Leicester';
   Club[7].Titles:=0;    

   Club[8].Team_Name:='Aston Villa';
   Club[8].Country:='England';
   Club[8].Manager:='Dean Smith';
   Club[8].Home_Stadium:='Villa Park';
   Club[8].Club_Name:='Aston Villa Football Club';
   Club[8].City:='Birmingham';
   Club[8].Titles:=1;    

   Club[9].Team_Name:='Nottingham Forest';
   Club[9].Country:='England';
   Club[9].Manager:='Aitor Karanka';
   Club[9].Home_Stadium:='City Ground';
   Club[9].Club_Name:='Nottingham Forest Football Club';
   Club[9].City:='Nottinghamshire';
   Club[9].Titles:=2;     

   Club[10].Team_Name:='Atletico Madrid';
   Club[10].Country:='Spain';
   Club[10].Manager:='Diego Simeone';
   Club[10].Home_Stadium:='Wanda Metropolitano';
   Club[10].Club_Name:='Club Atletico de Madrid';
   Club[10].City:='Madrid';
   Club[10].Titles:=0;    

   Club[11].Team_Name:='FC Barcelona';
   Club[11].Country:='Spain';
   Club[11].Manager:='Ernesto Valverde';
   Club[11].Home_Stadium:='Camp Nou';
   Club[11].Club_Name:='Futbol Club Barcelona';
   Club[11].City:='Barcelona';
   Club[11].Titles:=5;   

   Club[12].Team_Name:='Real Madrid';
   Club[12].Country:='Spain';
   Club[12].Manager:='Santiago Solari';
   Club[12].Home_Stadium:='Santiago Bernabeu';
   Club[12].Club_Name:='Real Madrid Club de Futbol';
   Club[12].City:='Madrid';
   Club[12].Titles:=13;      

   Club[13].Team_Name:='Sevilla';
   Club[13].Country:='Spain';
   Club[13].Manager:='Pablo Machin';
   Club[13].Home_Stadium:='Ramon Sanchez Pizjuan';
   Club[13].Club_Name:='Sevilla Futbol Club';
   Club[13].City:='Seville';
   Club[13].Titles:=0;     

   Club[14].Team_Name:='Valencia';
   Club[14].Country:='Spain';
   Club[14].Manager:='Marcelino Garcia Toral';
   Club[14].Home_Stadium:='Estadio Mestalla';
   Club[14].Club_Name:='Valencia Club de Futbol';
   Club[14].City:='Valencia';
   Club[14].Titles:=0;     

   Club[15].Team_Name:='Villareal';
   Club[15].Country:='Spain';
   Club[15].Manager:='Javier Calleja';
   Club[15].Home_Stadium:='El Madrigal';
   Club[15].Club_Name:='Villarreal Club de Futbol';
   Club[15].City:='Villarreal';
   Club[15].Titles:=0;    

   Club[16].Team_Name:='AC Milan';
   Club[16].Country:='Italy';
   Club[16].Manager:='Gennaro Gattuso';
   Club[16].Home_Stadium:='San Siro';
   Club[16].Club_Name:='Associazione Calcio Milan';
   Club[16].City:='Milan';
   Club[16].Titles:=7;   

   Club[17].Team_Name:='Inter Milan';
   Club[17].Country:='Italy';
   Club[17].Manager:='Luciano Spalletti';
   Club[17].Home_Stadium:='Giuseppe Meazza';
   Club[17].Club_Name:='Football Club Internazionale Milano';
   Club[17].City:='Milan';
   Club[17].Titles:=3;   

   Club[18].Team_Name:='Juventus';
   Club[18].Country:='Italy';
   Club[18].Manager:='Massimiliano Allegri';
   Club[18].Home_Stadium:='Juventus Stadium';
   Club[18].Club_Name:='Juventus Football Club';
   Club[18].City:='Turin';
   Club[18].Titles:=2;   

   Club[19].Team_Name:='AS Roma';
   Club[19].Country:='Italy';
   Club[19].Manager:='Eusebio Di Francesco';
   Club[19].Home_Stadium:='Stadio Olimpico';
   Club[19].Club_Name:='Associazione Sportiva Roma';
   Club[19].City:='Roma';
   Club[19].Titles:=0;    

   Club[20].Team_Name:='SSC Napoli';
   Club[20].Country:='Italy';
   Club[20].Manager:='Carlo Ancelotti';
   Club[20].Home_Stadium:='Stadio San Paolo';
   Club[20].Club_Name:='Societa Sportiva Calcio Napoli';
   Club[20].City:='Naples';
   Club[20].Titles:=0;   

   Club[21].Team_Name:='ACF Fiorentina';
   Club[21].Country:='Italy';
   Club[21].Manager:='Stefano Pioli';
   Club[21].Home_Stadium:=' Stadio Artemio Franchi';
   Club[21].Club_Name:='ACF Fiorentina';
   Club[21].City:='Florence';
   Club[21].Titles:=0;   

   Club[22].Team_Name:='FC Bayern Munchen';
   Club[22].Country:='Germany';
   Club[22].Manager:='Niko Kovac';
   Club[22].Home_Stadium:='Allianz Arena';
   Club[22].Club_Name:='Fussball-Club Bayern Muenchen';
   Club[22].City:='Munich';
   Club[22].Titles:=5;   

   Club[23].Team_Name:='Borussia Dortmund';
   Club[23].Country:='Germany';
   Club[23].Manager:='Lucien Favre';
   Club[23].Home_Stadium:='Signal Iduna Park';
   Club[23].Club_Name:='Ballspielverein Borussia 09';
   Club[23].City:='Dortmund';
   Club[23].Titles:=1;   

   Club[24].Team_Name:='Bayer Leverkusen';
   Club[24].Country:='Germany';
   Club[24].Manager:='Heiko Herrlich';
   Club[24].Home_Stadium:='BayArena';
   Club[24].Club_Name:='Bayer 04 Leverkusen Fussball';
   Club[24].City:='Leverkusen';
   Club[24].Titles:=0;      

   Club[25].Team_Name:='Schalke 04';
   Club[25].Country:='Germany';
   Club[25].Manager:='Domenico Tedesco';
   Club[25].Home_Stadium:='Veltins Arena';
   Club[25].Club_Name:='Fussballclub Gelsenkirchen-Schalke 04';
   Club[25].City:='Gelsenkirchen';
   Club[25].Titles:=0;     

   Club[26].Team_Name:='VfL Wolfsburg';
   Club[26].Country:='Germany';
   Club[26].Manager:='Bruno Labbadia';
   Club[26].Home_Stadium:='Volkswagen Arena';
   Club[26].Club_Name:='Verein fur Leibesubungen Wolfsburg';
   Club[26].City:='Wolfsburg';
   Club[26].Titles:=0;   

   Club[27].Team_Name:='Hamburger SV';
   Club[27].Country:='Germany';
   Club[27].Manager:='Hannes Wolf';
   Club[27].Home_Stadium:='Volksparkstadion';
   Club[27].Club_Name:='Hamburger Sport-Verein';
   Club[27].City:='Hamburg';
   Club[27].Titles:=1;           

   Club[28].Team_Name:='RB Leipzig';
   Club[28].Country:='Germany';
   Club[28].Manager:='Ralf Rangnick';
   Club[28].Home_Stadium:='Red Bull Arena';
   Club[28].Club_Name:='RasenBallsport Leipzig';
   Club[28].City:='Leipzig';
   Club[28].Titles:=0;   

   Club[29].Team_Name:='AS Monaco';
   Club[29].Country:='France';
   Club[29].Manager:='Thierry Henry';
   Club[29].Home_Stadium:='Stade Louis II';
   Club[29].Club_Name:='Association Sportive de Monaco Football Club';
   Club[29].City:='Monaco';
   Club[29].Titles:=0;   

   Club[30].Team_Name:='Olympique Marseille';
   Club[30].Country:='France';
   Club[30].Manager:='Rudi Garcia';
   Club[30].Home_Stadium:='Stade Velodrome';
   Club[30].Club_Name:='Olympique de Marseille';
   Club[30].City:='Marseille';
   Club[30].Titles:=1;

   Club[31].Team_Name:='Olympique Lyon';
   Club[31].Country:='France';
   Club[31].Manager:='Bruno Genesio';
   Club[31].Home_Stadium:='Parc Olympique Lyonnais';
   Club[31].Club_Name:='Olympique Lyonnais';
   Club[31].City:='Lyon';
   Club[31].Titles:=0;   

   Club[32].Team_Name:='Paris Saint Germain';
   Club[32].Country:='France';
   Club[32].Manager:='Thomas Tuchel';
   Club[32].Home_Stadium:='Parc des Princes';
   Club[32].Club_Name:='Paris Saint-Germain Football Club';
   Club[32].City:='Paris';
   Club[32].Titles:=0;   

   Club[33].Team_Name:='SL Benfica';
   Club[33].Country:='Portugal';
   Club[33].Manager:='Rui Vitoria';
   Club[33].Home_Stadium:='Estadio da Luz';
   Club[33].Club_Name:='Sport Lisboa e Benfica';
   Club[33].City:='Lisbon';
   Club[33].Titles:=2;   

   Club[34].Team_Name:='FC Porto';
   Club[34].Country:='Portugal';
   Club[34].Manager:='Sergio Conceicao';
   Club[34].Home_Stadium:='Estadio do Dragao';
   Club[34].Club_Name:='Futebol Clube do Porto';
   Club[34].City:='Porto';
   Club[34].Titles:=2;   

   Club[35].Team_Name:='Sporting CP';
   Club[35].Country:='Portugal';
   Club[35].Manager:='Tiago Fernandes';
   Club[35].Home_Stadium:='Estadio Jose Alvalade';
   Club[35].Club_Name:='Sporting Clube de Portugal';
   Club[35].City:='Lisbon';
   Club[35].Titles:=0;   

   Club[36].Team_Name:='Celtic FC';
   Club[36].Country:='Scotland';
   Club[36].Manager:='Brendan Rogers';
   Club[36].Home_Stadium:='Celtic Park';
   Club[36].Club_Name:='The Celtic Football Club';
   Club[36].City:='Glasgow';
   Club[36].Titles:=1;   

   Club[37].Team_Name:='Rangers FC';
   Club[37].Country:='Scotland';
   Club[37].Manager:='Steven Gerrard';
   Club[37].Home_Stadium:='Ibrox Stadium';
   Club[37].Club_Name:='Rangers Football Club';
   Club[37].City:='Glasgow';
   Club[37].Titles:=0;   

   Club[38].Team_Name:='AFC Ajax';
   Club[38].Country:='Netherlands';
   Club[38].Manager:='Erik ten Hag';
   Club[38].Home_Stadium:='Amsterdam ArenA';
   Club[38].Club_Name:='Amsterdamsche Football Club Ajax';
   Club[38].City:='Amsterdam';
   Club[38].Titles:=4;   

   Club[39].Team_Name:='Feyenoord';
   Club[39].Country:='Netherlands';
   Club[39].Manager:='Giovanni van Bronckhorst';
   Club[39].Home_Stadium:='De Kuip';
   Club[39].Club_Name:='Feyenoord Rotterdam';
   Club[39].City:='Rotterdam';
   Club[39].Titles:=1;   

   Club[40].Team_Name:='PSV Eindhoven';
   Club[40].Country:='Netherlands';
   Club[40].Manager:='Mark van Bommel';
   Club[40].Home_Stadium:='Philips Stadion';
   Club[40].Club_Name:='Philips Sport Vereniging';
   Club[40].City:='Eindhoven';
   Club[40].Titles:=1;   

   Club[41].Team_Name:='CSKA Moscow';
   Club[41].Country:='Russia';
   Club[41].Manager:='Viktor Goncharenko';
   Club[41].Home_Stadium:='VEB Arena';
   Club[41].Club_Name:='Professional`nyy futbol`nyy klub TSSKA Moskva';
   Club[41].City:='Moscow';
   Club[41].Titles:=0;   

   Club[42].Team_Name:='Spartak Moscow';
   Club[42].Country:='Russia';
   Club[42].Manager:='Raul Riancho';
   Club[42].Home_Stadium:='Otkrytie Arena';
   Club[42].Club_Name:='Futbol`nyy klub Spartak Moskva';
   Club[42].City:='Moscow';
   Club[42].Titles:=0;   

   Club[43].Team_Name:='Zenit St. Petersburg';
   Club[43].Country:='Russia';
   Club[43].Manager:='Sergei Semak';
   Club[43].Home_Stadium:='Petrovski Stadium';
   Club[43].Club_Name:='Futbol`nyy klub Zenit';
   Club[43].City:='Saint Petersburg';
   Club[43].Titles:=0;   

   Club[44].Team_Name:='Galatasaray SK';
   Club[44].Country:='Turkey';
   Club[44].Manager:='Fatih Terim';
   Club[44].Home_Stadium:='Turk Telekom Arena';
   Club[44].Club_Name:='Galatasaray Spor Kulubu';
   Club[44].City:='Istanbul';
   Club[44].Titles:=0;   

   Club[45].Team_Name:='Fenerbahce SK';
   Club[45].Country:='Turkey';
   Club[45].Manager:='Erwin Koeman';
   Club[45].Home_Stadium:='Sukru Saracoglu';
   Club[45].Club_Name:='Fenerbahce Spor Kulubu';
   Club[45].City:='Istanbul';
   Club[45].Titles:=0;   

   Club[46].Team_Name:='Besiktas JK';
   Club[46].Country:='Turkey';
   Club[46].Manager:='Senol Gunes';
   Club[46].Home_Stadium:='Ataturk Olympic Stadium';
   Club[46].Club_Name:='Besiktas Jimnastik Kulubu';
   Club[46].City:='Istanbul';
   Club[46].Titles:=0;   

   Club[47].Team_Name:='Dynamo Kyiv';
   Club[47].Country:='Ukraine';
   Club[47].Manager:='Aliaksandr Khatskevich';
   Club[47].Home_Stadium:='NSK Olimpijskyj';
   Club[47].Club_Name:='Football Club Dynamo Kyiv';
   Club[47].City:='Kiev';
   Club[47].Titles:=0;   

   Club[48].Team_Name:='Shaktar Donetsk';
   Club[48].Country:='Ukraine';
   Club[48].Manager:='Paulo Fonseca';
   Club[48].Home_Stadium:='Donbass Arena';
   Club[48].Club_Name:='Football Club Shakhtar Donetsk';
   Club[48].City:='Donetsk';
   Club[48].Titles:=0;   

   Club[49].Team_Name:='FC Basel';
   Club[49].Country:='Switzerland';
   Club[49].Manager:='Marcell Koller';
   Club[49].Home_Stadium:='St. Jakob Park';
   Club[49].Club_Name:='Fussball Club Basel 1893';
   Club[49].City:='Basel';
   Club[49].Titles:=0;   

   Club[50].Team_Name:='BSC Young Boys';
   Club[50].Country:='Switzerland';
   Club[50].Manager:='Gerardo Seoane';
   Club[50].Home_Stadium:='Stade de Suisse';
   Club[50].Club_Name:='Berner Sport Club Young Boys';
   Club[50].City:='Bern';
   Club[50].Titles:=0;   

   Club[51].Team_Name:='Malmo FF';
   Club[51].Country:='Sweden';
   Club[51].Manager:='Uwe Rosler';
   Club[51].Home_Stadium:='Swedbank Stadion';
   Club[51].Club_Name:='Malmo Fotbollforening';
   Club[51].City:='Malmo';
   Club[51].Titles:=0;   

   Club[52].Team_Name:='Red Star Belgrade';
   Club[52].Country:='Serbia';
   Club[52].Manager:='Vladan Milojevic';
   Club[52].Home_Stadium:='Red Star Stadium';
   Club[52].Club_Name:='Fudbalski klub Crvena Zvezda';
   Club[52].City:='Belgrade';
   Club[52].Titles:=1;   

   Club[53].Team_Name:='Legia Warsaw';
   Club[53].Country:='Poland';
   Club[53].Manager:='Ricardo Sa Pinto';
   Club[53].Home_Stadium:='Pepsi Arena';
   Club[53].Club_Name:='Legia Warszawa';
   Club[53].City:='Warsaw';
   Club[53].Titles:=0;   

   Club[54].Team_Name:='Olympiacos CFP';
   Club[54].Country:='Greece';
   Club[54].Manager:='Pedro Martins';
   Club[54].Home_Stadium:='Stadio Georgios Karaiskaki';
   Club[54].Club_Name:='Olympiakos Syndesmos Filathlon Peiraios';
   Club[54].City:='Piraeus';
   Club[54].Titles:=0;   

   Club[55].Team_Name:='Panathinaikos';
   Club[55].Country:='Greece';
   Club[55].Manager:='Giorgos Donis';
   Club[55].Home_Stadium:='Olympiako Stadio Spyros Louis';
   Club[55].Club_Name:='Panathinaikos Athlitikos Omilos';
   Club[55].City:='Athens';
   Club[55].Titles:=0;   

   Club[56].Team_Name:='FC Copenhagen';
   Club[56].Country:='Denmark';
   Club[56].Manager:='Stale Solbakken';
   Club[56].Home_Stadium:='Parken Stadion';
   Club[56].Club_Name:='Football Club Kobenhavn';
   Club[56].City:='Copenhagen';
   Club[56].Titles:=0;   

   Club[57].Team_Name:='Sparta Prague';
   Club[57].Country:='Czech Republic';
   Club[57].Manager:='Pavel Hapal';
   Club[57].Home_Stadium:='Generali-Arena';
   Club[57].Club_Name:='Athletic Club Sparta Praha Fotbal';
   Club[57].City:='Prague';
   Club[57].Titles:=0;   

   Club[58].Team_Name:='APOEL FC';
   Club[58].Country:='Cyprus';
   Club[58].Manager:='Thomas Christiansen';
   Club[58].Home_Stadium:='GSP Stadium';
   Club[58].Club_Name:='Athletikos Podosferikos Omilos Ellinon Lefkosias';
   Club[58].City:='Nicosia';
   Club[58].Titles:=0;   

   Club[59].Team_Name:='Dinamo Zagreb';
   Club[59].Country:='Croatia';
   Club[59].Manager:='Nenad Bjelica';
   Club[59].Home_Stadium:='Stadion Maksimir';
   Club[59].Club_Name:='Gradanski nogometni klub Dinamo Zagreb';
   Club[59].City:='Zagreb';
   Club[59].Titles:=0;   

   Club[60].Team_Name:='RSC Anderlecht';
   Club[60].Country:='Belgium';
   Club[60].Manager:='Hein Vanhaezebrouck';
   Club[60].Home_Stadium:='Stade Constant Vanden Stock';
   Club[60].Club_Name:='Royal Sporting Club Anderlecht';
   Club[60].City:='Anderlecht';
   Club[60].Titles:=0;   

   Club[61].Team_Name:='Club Brugge';
   Club[61].Country:='Belgium';
   Club[61].Manager:='Ivan Leko';
   Club[61].Home_Stadium:='Jan Breydelstadion';
   Club[61].Club_Name:='Club Brugge Koninklijke Voetbalvereniging';
   Club[61].City:='Bruges';
   Club[61].Titles:=0;   

   Club[62].Team_Name:='FK Austria Wien';
   Club[62].Country:='Austria';
   Club[62].Manager:='Thomas Letsch';
   Club[62].Home_Stadium:='Generali Arena';
   Club[62].Club_Name:='Fussballklub Austria Wien';
   Club[62].City:='Vienna';
   Club[62].Titles:=0;   

   Club[63].Team_Name:='Rosenborg BK';
   Club[63].Country:='Norway';
   Club[63].Manager:='Rini Coolen';
   Club[63].Home_Stadium:='Lerkendal Stadium';
   Club[63].Club_Name:='Rosenborg Ballklubb';
   Club[63].City:='Trondheim';
   Club[63].Titles:=0;   

   Club[64].Team_Name:='Steaua Bucuresti';
   Club[64].Country:='Romania';
   Club[64].Manager:='Nicolae Dica';
   Club[64].Home_Stadium:='Arena Nationala';
   Club[64].Club_Name:='Fotbal Club FCSB';
   Club[64].City:='Bucharest';
   Club[64].Titles:=1;                        
  end;

 function SelectTeam(Selected:integer):integer;
  label
   inputagain;
  var
   id,line:integer;
  begin
   inputagain:
   clrscr;
   gotoxy(65,2); write('=================================');
   gotoxy(65,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(65,4); write('=================================');

   gotoxy(73,6); write('===============');
   gotoxy(73,7); write('| SELECT TEAM |');
   gotoxy(73,8); write('===============');

     gotoxy(22,10); write('================================================================================================================');
     gotoxy(22,11); write('| No |'); gotoxy(40,11); write('Team'); gotoxy(59,11); write('| No |'); gotoxy(78,11); write('Team'); gotoxy(96,11); write('| No |'); gotoxy(115,11); write('Team'); gotoxy(133,11); write('|'); 
     gotoxy(22,12); write('================================================================================================================');
     line:=13;     
   for id:=1 to 22 do
    begin
     gotoxy(22,line); write('| ',id); gotoxy(27,line); write('| ',Club[id].Team_Name,' (',Club[id].Country,')');
     gotoxy(59,line); write('| ',id+22); gotoxy(64,line); write('| ',Club[id+22].Team_Name,' (',Club[id+22].Country,')');
     gotoxy(96,line); write('| '); gotoxy(101,line); write('| '); gotoxy(133,line); write('|');    
     if (id+44<=64) then
      begin
       gotoxy(98,line); write(id+44); gotoxy(103,line); write(Club[id+44].Team_Name,' (',Club[id+44].Country,')');
      end;    
     line:=line+1;     
    end;
   gotoxy(22,line); writeln('================================================================================================================'); 

   repeat
    gotoxy(66,line+2); write('* Select Team (Input Number): '); readln(Selected);
    if (Selected<1) OR (Selected>64) then
     begin
      gotoxy(66,line+4); writeln('- Please Select your Team Correctly!');
      readln;
      GoTo inputagain;
     end;
   until (Selected>=1) and (Selected<=64);
   SelectTeam:=Selected;
  end;

 function InputPlayerName(Player:string):integer;
  label
   showagain;
  var
   menu:integer;
  begin
   showagain:
   clrscr;
   gotoxy(65,2); write('=================================');
   gotoxy(65,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(65,4); write('=================================');

   gotoxy(61,6); write('======================================');
   gotoxy(61,7); write('|              Selected Team :'); gotoxy(98,7); write('|');
   gotoxy(61,8); write('| ',UpCase(Club[Participant.MyTeam_ID].Team_Name),' (',Club[Participant.MyTeam_ID].Country,')');  gotoxy(98,8); write('|');
   gotoxy(61,9); write('| Manager : ',Player); gotoxy(98,9); write('|');
   gotoxy(61,10); write('======================================');

   gotoxy(66,12); write('============================');
   gotoxy(66,13); write('| 1. Advance               |');
   gotoxy(66,14); write('| 2. Change Manager`s Name |');
   gotoxy(66,15); write('| 3. Change Team           |');
   gotoxy(66,16); write('============================');
   gotoxy(68,18); write('* Select Menu : '); readln(menu);
    if (menu<1) OR (menu>3) then
     begin
      gotoxy(68,21); write('* Message :');
      gotoxy(68,22); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;
   if (menu=2) then
    begin
     gotoxy(68,21); write('* Input your Name : '); readln(Player);
     Club[Participant.MyTeam_ID].Manager:=Player;
     GoTo showagain;
    end;
   InputPlayerName:=menu;
   end;

 procedure Set_Final_Host;
  begin
   randomize;
   Final_Host:=(random(64)+1);
   KnockOutMatch[29].Venue:=Club[Final_Host].Home_Stadium;
  end;

 procedure GroupPotSeeding;
  var
   i,j,number:integer;
   duplicate,consist_myteam:boolean;   
  begin
   randomize;
   repeat
    for i:=1 to 32 do
     begin
      repeat
       duplicate:=FALSE; 
       number:=(random(64)+1);
       for j:=1 to 32 do
        begin
         duplicate:=duplicate OR (number=Pot[j]);
        end;
      until (duplicate=FALSE);
      Pot[i]:=number;
     end;

     consist_myteam:=FALSE;
     for i:=1 to 32 do
      begin
       consist_myteam:=consist_myteam OR (Pot[i]=Participant.MyTeam_ID);
      end;

   until (consist_myteam=TRUE);
   for i:=1 to 32 do
    begin
     Participant.ParticipantArray[i]:=Pot[i];
    end;
  end;

 function GroupDrawing(menu:integer):integer;
  label
   showagain;
  var
   group_num,team_num,pot_num:integer;
  begin
   GroupPotSeeding;
   showagain:
   clrscr;   
   pot_num:=1;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(73,6); write('====================');
   gotoxy(73,7); write('| GROUP STAGE DRAW |');
   gotoxy(73,8); write('====================');

   for group_num:=1 to 8 do
    begin
     for team_num:=1 to 4 do
      begin
       Group[group_num,team_num].Team_ID:=Club[Pot[pot_num]].Team_ID;
       GroupRankings[group_num,team_num]:=team_num;
       Club[Pot[pot_num]].Group:=chr(group_num+64);
       if (Group[group_num,team_num].Team_ID=Participant.MyTeam_ID) then
        begin
         Participant.MyTeam_Group:=group_num;
        end;
       pot_num:=pot_num+1;
      end;
    end; 

     gotoxy(13,10); write('==================================');
     gotoxy(13,11); write('|'); gotoxy(27,11); write('Group A'); gotoxy(46,11); write('|');
     gotoxy(13,12); write('==================================');
     gotoxy(13,17); write('==================================');

     gotoxy(48,10); write('==================================');
     gotoxy(48,11); write('|'); gotoxy(62,11); write('Group B'); gotoxy(81,11); write('|');
     gotoxy(48,12); write('==================================');
     gotoxy(48,17); write('==================================');

     gotoxy(83,10); write('==================================');
     gotoxy(83,11); write('|'); gotoxy(97,11); write('Group C'); gotoxy(116,11); write('|');
     gotoxy(83,12); write('==================================');
     gotoxy(83,17); write('==================================');

     gotoxy(118,10); write('==================================');
     gotoxy(118,11); write('|'); gotoxy(132,11); write('Group D'); gotoxy(151,11); write('|');
     gotoxy(118,12); write('==================================');
     gotoxy(118,17); write('==================================');

     gotoxy(13,19); write('==================================');
     gotoxy(13,20); write('|'); gotoxy(27,20); write('Group E'); gotoxy(46,20); write('|');
     gotoxy(13,21); write('==================================');
     gotoxy(13,26); write('==================================');

     gotoxy(48,19); write('==================================');
     gotoxy(48,20); write('|'); gotoxy(62,20); write('Group F'); gotoxy(81,20); write('|');
     gotoxy(48,21); write('==================================');
     gotoxy(48,26); write('==================================');

     gotoxy(83,19); write('==================================');
     gotoxy(83,20); write('|'); gotoxy(97,20); write('Group G'); gotoxy(116,20); write('|');
     gotoxy(83,21); write('==================================');
     gotoxy(83,26); write('==================================');

     gotoxy(118,19); write('==================================');
     gotoxy(118,20); write('|'); gotoxy(132,20); write('Group H'); gotoxy(151,20); write('|');
     gotoxy(118,21); write('==================================');
     gotoxy(118,26); write('==================================');
     for team_num:=1 to 4 do
      begin       
       gotoxy(13,team_num+12); write('| ',Club[Group[1,team_num].Team_ID].Team_Name,' (',Club[Group[1,team_num].Team_ID].Country,')'); gotoxy(46,team_num+12); write('|');
       gotoxy(48,team_num+12); write('| ',Club[Group[2,team_num].Team_ID].Team_Name,' (',Club[Group[2,team_num].Team_ID].Country,')'); gotoxy(81,team_num+12); write('|');
       gotoxy(83,team_num+12); write('| ',Club[Group[3,team_num].Team_ID].Team_Name,' (',Club[Group[3,team_num].Team_ID].Country,')'); gotoxy(116,team_num+12); write('|');
       gotoxy(118,team_num+12); write('| ',Club[Group[4,team_num].Team_ID].Team_Name,' (',Club[Group[4,team_num].Team_ID].Country,')'); gotoxy(151,team_num+12); write('|');

       gotoxy(13,team_num+21); write('| ',Club[Group[5,team_num].Team_ID].Team_Name,' (',Club[Group[5,team_num].Team_ID].Country,')'); gotoxy(46,team_num+21); write('|');
       gotoxy(48,team_num+21); write('| ',Club[Group[6,team_num].Team_ID].Team_Name,' (',Club[Group[6,team_num].Team_ID].Country,')'); gotoxy(81,team_num+21); write('|');
       gotoxy(83,team_num+21); write('| ',Club[Group[7,team_num].Team_ID].Team_Name,' (',Club[Group[7,team_num].Team_ID].Country,')'); gotoxy(116,team_num+21); write('|');
       gotoxy(118,team_num+21); write('| ',Club[Group[8,team_num].Team_ID].Team_Name,' (',Club[Group[8,team_num].Team_ID].Country,')'); gotoxy(151,team_num+21); write('|');        
      end;
   gotoxy(50,28); write('==================================================================');
   gotoxy(50,29); write('| 1.Start Tournament       2.Redraw     3.Change Team and Redraw |');
   gotoxy(50,30); write('==================================================================');
    gotoxy(71,32); write('* Select Menu : '); readln(menu);
    gotoxy(68,34); writeln;
    gotoxy(68,35); writeln;
    if (menu<1) OR (menu>3) then
     begin
      gotoxy(64,34); write('* Message :');
      gotoxy(64,35); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;
   if (menu=1) then
    begin
     gotoxy(61,34); write('Press Enter to Start the UEFA Champions League...');
     readln;
    end;
   GroupDrawing:=menu;    
   end;

 procedure GroupMatchData;
  var
   my,id,md,group_num,match_num:integer;
  begin
   clrscr;
   for group_num:=1 to 8 do
    begin
     Match[group_num,1].Home_Team:=Group[group_num,1].Team_ID;
	 Match[group_num,1].Home_Code:=1;     
     Match[group_num,1].Away_Team:=Group[group_num,3].Team_ID;
	 Match[group_num,1].Away_Code:=3;       
     Match[group_num,1].Venue:=Club[Group[group_num,1].Team_ID].Home_Stadium;

     Match[group_num,2].Home_Team:=Group[group_num,4].Team_ID;
	 Match[group_num,2].Home_Code:=4;
	 Match[group_num,2].Away_Code:=2;     
     Match[group_num,2].Away_Team:=Group[group_num,2].Team_ID;
     Match[group_num,2].Venue:=Club[Group[group_num,4].Team_ID].Home_Stadium;    

     Match[group_num,3].Home_Team:=Group[group_num,2].Team_ID;
	 Match[group_num,3].Home_Code:=2;
	 Match[group_num,3].Away_Code:=1;     
     Match[group_num,3].Away_Team:=Group[group_num,1].Team_ID;
     Match[group_num,3].Venue:=Club[Group[group_num,2].Team_ID].Home_Stadium;

     Match[group_num,4].Home_Team:=Group[group_num,3].Team_ID;
	 Match[group_num,4].Home_Code:=3;
	 Match[group_num,4].Away_Code:=4;     
     Match[group_num,4].Away_Team:=Group[group_num,4].Team_ID;
     Match[group_num,4].Venue:=Club[Group[group_num,3].Team_ID].Home_Stadium;     

     Match[group_num,5].Home_Team:=Group[group_num,1].Team_ID;
	 Match[group_num,5].Home_Code:=1;
	 Match[group_num,5].Away_Code:=4;     
     Match[group_num,5].Away_Team:=Group[group_num,4].Team_ID;
     Match[group_num,5].Venue:=Club[Group[group_num,1].Team_ID].Home_Stadium;

     Match[group_num,6].Home_Team:=Group[group_num,2].Team_ID;
	 Match[group_num,6].Home_Code:=2;
	 Match[group_num,6].Away_Code:=3;     
     Match[group_num,6].Away_Team:=Group[group_num,3].Team_ID;
     Match[group_num,6].Venue:=Club[Group[group_num,2].Team_ID].Home_Stadium;     

     Match[group_num,7].Home_Team:=Group[group_num,4].Team_ID;
	 Match[group_num,7].Home_Code:=4;
	 Match[group_num,7].Away_Code:=1;     
     Match[group_num,7].Away_Team:=Group[group_num,1].Team_ID;
     Match[group_num,7].Venue:=Club[Group[group_num,4].Team_ID].Home_Stadium;

     Match[group_num,8].Home_Team:=Group[group_num,3].Team_ID;
	 Match[group_num,8].Home_Code:=3;
	 Match[group_num,8].Away_Code:=2;     
     Match[group_num,8].Away_Team:=Group[group_num,2].Team_ID;
     Match[group_num,8].Venue:=Club[Group[group_num,3].Team_ID].Home_Stadium;     

     Match[group_num,9].Home_Team:=Group[group_num,1].Team_ID;
	 Match[group_num,9].Home_Code:=1;
	 Match[group_num,9].Away_Code:=2;     
     Match[group_num,9].Away_Team:=Group[group_num,2].Team_ID;
     Match[group_num,9].Venue:=Club[Group[group_num,1].Team_ID].Home_Stadium;

     Match[group_num,10].Home_Team:=Group[group_num,4].Team_ID;
	 Match[group_num,10].Home_Code:=4;
	 Match[group_num,10].Away_Code:=3;     
     Match[group_num,10].Away_Team:=Group[group_num,3].Team_ID;
     Match[group_num,10].Venue:=Club[Group[group_num,4].Team_ID].Home_Stadium;     

     Match[group_num,11].Home_Team:=Group[group_num,3].Team_ID;
	 Match[group_num,11].Home_Code:=3;
	 Match[group_num,11].Away_Code:=1;     
     Match[group_num,11].Away_Team:=Group[group_num,1].Team_ID;
     Match[group_num,11].Venue:=Club[Group[group_num,3].Team_ID].Home_Stadium;

     Match[group_num,12].Home_Team:=Group[group_num,2].Team_ID;
	 Match[group_num,12].Home_Code:=2;
	 Match[group_num,12].Away_Code:=4;     
     Match[group_num,12].Away_Team:=Group[group_num,4].Team_ID;
     Match[group_num,12].Venue:=Club[Group[group_num,2].Team_ID].Home_Stadium;                                         
    end;

    id:=1;
    my:=1;
    for group_num:=1 to 8 do
     begin
      md:=1;
      for match_num:=1 to 12 do
       begin
        Match[group_num,match_num].Phase:='Group Stage';
        if (match_num mod 2>0) then
         begin
          Match[group_num,match_num].Matchday:=md;
          Match[group_num,(match_num+1)].Matchday:=md;
          md:=md+1; 
         end;
        if (Match[group_num,match_num].Home_Team=Participant.MyTeam_ID) then
         begin
          Participant.MyTeam_Match[my].Match_ID:=match_num;
          Participant.MyTeam_Match[my].Status:='Home';
          my:=my+1;
         end
        else if (Match[group_num,match_num].Away_Team=Participant.MyTeam_ID) then
         begin
          Participant.MyTeam_Match[my].Match_ID:=match_num;
          Participant.MyTeam_Match[my].Status:='Away';
          my:=my+1;
         end;          

        id:=id+1;
       end;
   end;
   end;

 function Search_Data(search,command:string):boolean;
  var
   i,temp:integer;
   found:boolean;
  begin
   i:=1;
   found:=FALSE;
   while (i<=32) AND (not(found)) do
    begin
     if (command='Team') AND (UpCase(search)=UpCase(Club[Participant.ParticipantArray[i]].Team_Name)) then
      begin
       temp:=Participant.ParticipantArray[1];
       Participant.ParticipantArray[1]:=Participant.ParticipantArray[i];
       Participant.ParticipantArray[i]:=temp;       
       found:=TRUE;
      end
     else if (command='Manager') AND (UpCase(search)=UpCase(Club[Participant.ParticipantArray[i]].Manager)) then
      begin
       temp:=Participant.ParticipantArray[1];
       Participant.ParticipantArray[1]:=Participant.ParticipantArray[i];
       Participant.ParticipantArray[i]:=temp;       
       found:=TRUE;
      end
     else if (command='Stadium') AND (UpCase(search)=UpCase(Club[Participant.ParticipantArray[i]].Home_Stadium)) then
      begin
       temp:=Participant.ParticipantArray[1];
       Participant.ParticipantArray[1]:=Participant.ParticipantArray[i];
       Participant.ParticipantArray[i]:=temp;       
       found:=TRUE;
      end;      
      i:=i+1;
    end;
    Search_Data:=found; 
  end;

 procedure Sorting_Data(command:string;n:integer);
  var
   i,j,temp:integer;
  begin
   for i:=1 to n-1 do
    begin
     for j:=n-1 downto 1 do
      begin
       if (command='Ascending') AND (Club[Participant.ParticipantArray[j]].Team_Name>Club[Participant.ParticipantArray[j+1]].Team_Name) then
        begin
         temp:=Participant.ParticipantArray[j];
         Participant.ParticipantArray[j]:=Participant.ParticipantArray[j+1];
         Participant.ParticipantArray[j+1]:=temp;
        end
       else if (command='Descending') AND (Club[Participant.ParticipantArray[j]].Team_Name<Club[Participant.ParticipantArray[j+1]].Team_Name) then
        begin
         temp:=Participant.ParticipantArray[j];
         Participant.ParticipantArray[j]:=Participant.ParticipantArray[j+1];
         Participant.ParticipantArray[j+1]:=temp;
        end
       else if (command='Titles') AND (Club[Participant.ParticipantArray[j]].Titles<Club[Participant.ParticipantArray[j+1]].Titles) then
        begin
         temp:=Participant.ParticipantArray[j];
         Participant.ParticipantArray[j]:=Participant.ParticipantArray[j+1];
         Participant.ParticipantArray[j+1]:=temp;
        end;               
      end;
    end;
  end;

 procedure Filter_Data(filter,command:string;var found:integer);
  var
   i,temp:integer;
  begin
   found:=0;
   for i:=1 to 32 do
    begin
     if (command='Country') AND (UpCase(filter)=UpCase(Club[Participant.ParticipantArray[i]].Country)) then
      begin
       found:=found+1;
       temp:=Participant.ParticipantArray[found];
       Participant.ParticipantArray[found]:=Participant.ParticipantArray[i];
       Participant.ParticipantArray[i]:=temp;      
      end
     else if (command='Group') AND (UpCase(filter)=UpCase(Club[Participant.ParticipantArray[i]].Group)) then
      begin
       found:=found+1;
       temp:=Participant.ParticipantArray[found];
       Participant.ParticipantArray[found]:=Participant.ParticipantArray[i];
       Participant.ParticipantArray[i]:=temp; 
      end;  
    end; 
  end;



 function Search_Stats(command:string):integer;
  var
   i,target:integer;
  begin
   target:=1;
   for i:=2 to 32 do
    begin
     if (command='Most Wins') AND (Club[Participant.ParticipantArray[i]].Wins>Club[Participant.ParticipantArray[target]].Wins) then
      begin
       target:=i;
      end;
     if (command='Most Draws') AND (Club[Participant.ParticipantArray[i]].Draws>Club[Participant.ParticipantArray[target]].Draws) then
      begin
       target:=i;
      end;
     if (command='Most Loss') AND (Club[Participant.ParticipantArray[i]].Losses>Club[Participant.ParticipantArray[target]].Losses) then
      begin
       target:=i;
      end;
     if (command='Best Attack') AND (Club[Participant.ParticipantArray[i]].Goals_Scored>Club[Participant.ParticipantArray[target]].Goals_Scored) then
      begin
       target:=i;
      end;
     if (command='Best Defence') AND (Club[Participant.ParticipantArray[i]].Goals_Conceded<Club[Participant.ParticipantArray[target]].Goals_Conceded) then
      begin
       target:=i;
      end;
     if (command='Poor Attack') AND (Club[Participant.ParticipantArray[i]].Goals_Scored<Club[Participant.ParticipantArray[target]].Goals_Scored) then
      begin
       target:=i;
      end;
     if (command='Poor Defence') AND (Club[Participant.ParticipantArray[i]].Goals_Conceded>Club[Participant.ParticipantArray[target]].Goals_Conceded) then
      begin
       target:=i;
      end;
     if (command='Most Cleansheet') AND (Club[Participant.ParticipantArray[i]].Cleansheet>Club[Participant.ParticipantArray[target]].Cleansheet) then
      begin
       target:=i;
      end;
    end;
   Search_Stats:=Participant.ParticipantArray[target];
  end;                     
   

 procedure SimulateMatch(md:integer);
  var
   group_num,match_num:integer;
  begin
   for group_num:=1 to 8 do
    begin
     for match_num:=md to md+1 do
      begin
       Match[group_num,match_num].Home_Score:=random(7);
       Match[group_num,match_num].Away_Score:=random(7); 
      end;
     end;
  end;

 procedure CalculateMatchResults(md:integer);
  var
   g,m,t,h,HWin,TWin,HAggregate,TAggregate,temp:integer;
  begin
   for g:=1 to 8 do
    begin
     for m:=md to md+1 do
      begin
       Group[g,Match[g,m].Home_Code].Played:=Group[g,Match[g,m].Home_Code].Played+1;
       Group[g,Match[g,m].Home_Code].Goals_Scored:=Group[g,Match[g,m].Home_Code].Goals_Scored+Match[g,m].Home_Score;
       Group[g,Match[g,m].Home_Code].Goals_Conceded:=Group[g,Match[g,m].Home_Code].Goals_Conceded+Match[g,m].Away_Score;
       Group[g,Match[g,m].Home_Code].Goals_Difference:=Group[g,Match[g,m].Home_Code].Goals_Difference+(Match[g,m].Home_Score-Match[g,m].Away_Score);       

       Group[g,Match[g,m].Away_Code].Played:=Group[g,Match[g,m].Away_Code].Played+1;
       Group[g,Match[g,m].Away_Code].Goals_Scored:=Group[g,Match[g,m].Away_Code].Goals_Scored+Match[g,m].Away_Score;
       Group[g,Match[g,m].Away_Code].Goals_Conceded:=Group[g,Match[g,m].Away_Code].Goals_Conceded+Match[g,m].Home_Score;
       Group[g,Match[g,m].Away_Code].Goals_Difference:=Group[g,Match[g,m].Away_Code].Goals_Difference+(Match[g,m].Away_Score-Match[g,m].Home_Score);       

       if (Match[g,m].Home_Score>Match[g,m].Away_Score) then
        begin
         Group[g,Match[g,m].Home_Code].Win:=Group[g,Match[g,m].Home_Code].Win+1;
         Group[g,Match[g,m].Away_Code].Loss:=Group[g,Match[g,m].Away_Code].Loss+1;
         Group[g,Match[g,m].Home_Code].Points:=Group[g,Match[g,m].Home_Code].Points+3;         
        end
       else if (Match[g,m].Away_Score>Match[g,m].Home_Score) then
        begin
         Group[g,Match[g,m].Home_Code].Loss:=Group[g,Match[g,m].Home_Code].Loss+1;
         Group[g,Match[g,m].Away_Code].Win:=Group[g,Match[g,m].Away_Code].Win+1;
         Group[g,Match[g,m].Away_Code].Points:=Group[g,Match[g,m].Away_Code].Points+3;          
        end
       else if (Match[g,m].Home_Score=Match[g,m].Away_Score) then
        begin
         Group[g,Match[g,m].Home_Code].Draw:=Group[g,Match[g,m].Home_Code].Draw+1;
         Group[g,Match[g,m].Away_Code].Draw:=Group[g,Match[g,m].Away_Code].Draw+1;
         Group[g,Match[g,m].Home_Code].Points:=Group[g,Match[g,m].Home_Code].Points+1;
         Group[g,Match[g,m].Away_Code].Points:=Group[g,Match[g,m].Away_Code].Points+1;    
        end;


       Club[Group[g,Match[g,m].Home_Code].Team_ID].Played:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Played+1;
       Club[Group[g,Match[g,m].Away_Code].Team_ID].Played:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Played+1;
       Club[Group[g,Match[g,m].Home_Code].Team_ID].Goals_Scored:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Goals_Scored+Match[g,m].Home_Score;
       Club[Group[g,Match[g,m].Home_Code].Team_ID].Goals_Conceded:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Goals_Conceded+Match[g,m].Away_Score;       
       Club[Group[g,Match[g,m].Away_Code].Team_ID].Goals_Scored:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Goals_Scored+Match[g,m].Away_Score;
       Club[Group[g,Match[g,m].Away_Code].Team_ID].Goals_Conceded:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Goals_Conceded+Match[g,m].Home_Score;

       if (Match[g,m].Home_Score>Match[g,m].Away_Score) then
        begin
         Club[Group[g,Match[g,m].Home_Code].Team_ID].Wins:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Wins+1;
         Club[Group[g,Match[g,m].Away_Code].Team_ID].Losses:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Losses+1;       
        end
       else if (Match[g,m].Away_Score>Match[g,m].Home_Score) then
        begin
         Club[Group[g,Match[g,m].Away_Code].Team_ID].Wins:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Wins+1;
         Club[Group[g,Match[g,m].Home_Code].Team_ID].Losses:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Losses+1;        
        end
       else if (Match[g,m].Home_Score=Match[g,m].Away_Score) then
        begin
         Club[Group[g,Match[g,m].Home_Code].Team_ID].Draws:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Draws+1;
         Club[Group[g,Match[g,m].Away_Code].Team_ID].Draws:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Draws+1;    
        end;

       if (Match[g,m].Away_Score=0) then
        begin
         Club[Group[g,Match[g,m].Home_Code].Team_ID].Cleansheet:=Club[Group[g,Match[g,m].Home_Code].Team_ID].Cleansheet+1;        
        end;
       if (Match[g,m].Home_Score=0) then
        begin
         Club[Group[g,Match[g,m].Away_Code].Team_ID].Cleansheet:=Club[Group[g,Match[g,m].Away_Code].Team_ID].Cleansheet+1;        
        end;        
      end;
    end;

   for g:=1 to 8 do
    begin
     for m:=1 to 3 do
      begin
       for t:=m to 4 do
        begin

         HWin:=0;
         TWin:=0;
         HAggregate:=0;
         TAggregate:=0;
         for h:=1 to 12 do
          begin
           if ((Match[g,h].Home_Code=GroupRankings[g,m]) AND (Match[g,h].Away_Code=GroupRankings[g,t])) then
            begin
             HAggregate:=HAggregate+Match[g,h].Home_Score;
             TAggregate:=TAggregate+Match[g,h].Away_Score;             
             if (Match[g,h].Home_Score>Match[g,h].Away_Score) then
              begin
               Hwin:=HWin+1;
              end
             else if (Match[g,h].Home_Score<Match[g,h].Away_Score) then
              begin
               TWin:=TWin+1;
              end;
            end
           else if ((Match[g,h].Home_Code=GroupRankings[g,t]) AND (Match[g,h].Away_Code=GroupRankings[g,m])) then
            begin
             HAggregate:=HAggregate+Match[g,h].Away_Score;
             TAggregate:=TAggregate+Match[g,h].Home_Score;           
             if (Match[g,h].Home_Score>Match[g,h].Away_Score) then
              begin
               Twin:=TWin+1;
              end
             else if (Match[g,h].Home_Score<Match[g,h].Away_Score) then
              begin
               HWin:=HWin+1;
              end;
            end;
          end;

         if (Group[g,GroupRankings[g,t]].Points>Group[g,GroupRankings[g,m]].Points) then
          begin
           temp:=GroupRankings[g,t];
           GroupRankings[g,t]:=GroupRankings[g,m];
           GroupRankings[g,m]:=temp;
          end
         else if (Group[g,GroupRankings[g,t]].Points=Group[g,GroupRankings[g,m]].Points) AND (Group[g,GroupRankings[g,t]].Goals_Difference>Group[g,GroupRankings[g,m]].Goals_Difference) then
          begin
           temp:=GroupRankings[g,t];
           GroupRankings[g,t]:=GroupRankings[g,m];
           GroupRankings[g,m]:=temp;
          end
         else if (Group[g,GroupRankings[g,t]].Points=Group[g,GroupRankings[g,m]].Points) AND (TWin>HWin) then
          begin
           temp:=GroupRankings[g,t];
           GroupRankings[g,t]:=GroupRankings[g,m];
           GroupRankings[g,m]:=temp;
          end
         else if (Group[g,GroupRankings[g,t]].Points=Group[g,GroupRankings[g,m]].Points) AND (TAggregate>HAggregate) then
          begin
           temp:=GroupRankings[g,t];
           GroupRankings[g,t]:=GroupRankings[g,m];
           GroupRankings[g,m]:=temp;
          end;          

        end;
      end;
    end;
  end;

 procedure ViewMatchResults(command:string;md:integer);
  var
   g,m,line:integer;
  begin
   clrscr;
   if (command='Simulate') then
    begin
     SimulateMatch(md);
    end;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(74,6); write('=================');
   gotoxy(74,7); write('| MATCH RESULTS |');
   gotoxy(74,8); write('=================');

   gotoxy(69,10); write('==========================');
   gotoxy(69,11); write('| GROUP STAGE MATCHDAY ',Match_Code,' |');
   gotoxy(69,12); write('==========================');   
   writeln;
   line:=14;
   for g:=1 to 8 do
    begin
     gotoxy(58,line); write('==================================================');
     gotoxy(58,line+1); write('|                    Group ',chr(64+g)); gotoxy(107,line+1); write('|');
     gotoxy(58,line+2); write('==================================================');
     for m:=md to md+1 do
      begin
       gotoxy(58,line+3); write('| ',Club[Match[g,m].Home_Team].Team_Name,' ',Match[g,m].Home_Score,' - ',Match[g,m].Away_Score,' ',Club[Match[g,m].Away_Team].Team_Name); gotoxy(107,line+3); write('|');
       gotoxy(58,line+4); write('| Venue : ',Match[g,m].Venue); gotoxy(107,line+4); write('|');
       gotoxy(58,line+5); write('==================================================');
       line:=line+3;
      end; 
     writeln;
     line:=line+4;
    end;

      gotoxy(67,line+1); write('Press Enter to Continue...');
      readln;
  end;


  procedure View_Group_Standings;
   var
    g,t,line:integer;
   begin
    clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(71,6); write('=========================');
   gotoxy(71,7); write('| GROUP STAGE STANDINGS |');
   gotoxy(71,8); write('=========================');

   line:=10;
   for g:=1 to 8 do
    begin
     gotoxy(50,line); write('====================================================================');
     gotoxy(50,line+1); write('|                              Group ',chr(64+g)); gotoxy(117,line+1); write('|');
     gotoxy(50,line+2); write('====================================================================');
     gotoxy(50,line+3); write('|        Team'); gotoxy(75,line+3); write('|');
     gotoxy(77,line+3); write('P  |');
     gotoxy(82,line+3); write('W  |');
     gotoxy(87,line+3); write('D  |'); 
     gotoxy(92,line+3); write('L  |'); 
     gotoxy(97,line+3); write('GS |');
     gotoxy(102,line+3); write('GC |');
     gotoxy(107,line+3); write(' GD |');
     gotoxy(113,line+3); write('Pts |');
     gotoxy(50,line+4); write('====================================================================');  
     line:=line+5;
    for t:=1 to 4 do
     begin
      gotoxy(50,line); write('| ',Club[Group[g,GroupRankings[g,t]].Team_ID].Team_Name); gotoxy(75,line); write('|');
      gotoxy(77,line); write(Group[g,GroupRankings[g,t]].Played); gotoxy(80,line); write('|');
      gotoxy(82,line); write(Group[g,GroupRankings[g,t]].Win); gotoxy(85,line); write('|');
      gotoxy(87,line); write(Group[g,GroupRankings[g,t]].Draw); gotoxy(90,line); write('|');
      gotoxy(92,line); write(Group[g,GroupRankings[g,t]].Loss); gotoxy(95,line); write('|');
      gotoxy(97,line); write(Group[g,GroupRankings[g,t]].Goals_Scored); gotoxy(100,line); write('|');
      gotoxy(102,line); write(Group[g,GroupRankings[g,t]].Goals_Conceded); gotoxy(105,line); write('|');
      gotoxy(107,line); write(Group[g,GroupRankings[g,t]].Goals_Difference); gotoxy(111,line); write('|');
      gotoxy(113,line); write(Group[g,GroupRankings[g,t]].Points); gotoxy(117,line); write('|');
      line:=line+1;    
     end;
     gotoxy(50,line); write('====================================================================');
     line:=line+2;
     writeln;
     end;
    gotoxy(66,line+2); write('Press Enter to Continue...');
    readln;
  end;

 procedure KnockOut_Drawing(locate:string);
  label
   skip;
  var
   my,m,g,t,r,p,number:integer;
   duplicate:boolean;
  begin
   if (locate='Round of 16') then
   begin
   t:=1;
   g:=1;
   while (t<=8) do
    begin
     Pot[t]:=Group[g,GroupRankings[g,1]].Team_ID;
     Pot[t+8]:=Group[g,GroupRankings[g,2]].Team_ID;
     g:=g+1;
     t:=t+1;
    end;
  end;

    case (locate) of
    'Round of 16' : begin
                     m:=1;
                     p:=8;
                     r:=8;
                     my:=7;        
                    end;
    'Quarter Final' : begin
         m:=17;
         p:=4;
         r:=20;
         my:=9;          
        end;
    'Semifinal' : begin
         m:=25;
         p:=2;
         r:=26;
         my:=11;         
        end;
    'Final' : begin
         KnockOutMatch[29].Phase:='The Final';
         KnockOutMatch[29].Matchday:=1;
         KnockOutMatch[29].Home_Team:=Pot[1];
         KnockOutMatch[29].Away_Team:=Pot[2];
         KnockOutMatch[29].Venue:=Club[Final_Host].Home_Stadium;
      if (KnockOutMatch[29].Home_Team=Participant.MyTeam_ID) OR (KnockOutMatch[29].Away_Team=Participant.MyTeam_ID) then
       begin
        Participant.MyTeam_Match[13].Match_ID:=29;
       end;         
         GoTo skip;
        end;
    end;

   randomize;
    for t:=m to r do
     begin
     repeat
       duplicate:=FALSE; 
       number:=(random(p*2)+1);
       for g:=m to p+r do
        begin
         duplicate:=duplicate OR ((KnockOutMatch[g].Home_Team=Pot[number]) OR (KnockOutMatch[g].Away_Team=Pot[number]));
        end;
      until (duplicate=FALSE);
      KnockOutMatch[t].Home_Team:=Pot[number];     
    end;

    for t:=m to r do
     begin
     repeat
       duplicate:=FALSE; 
       number:=(random(p*2)+1);
       for g:=m to p+r do
        begin
         duplicate:=duplicate OR ((KnockOutMatch[g].Home_Team=Pot[number]) OR (KnockOutMatch[g].Away_Team=Pot[number]));
        end;
      until (duplicate=FALSE);
      KnockOutMatch[t].Away_Team:=Pot[number];
    end;

    for t:=m+p to p+r do
     begin
    case (locate) of
    'Round of 16' : begin
         KnockOutMatch[t-p].Phase:='Round of 16';
         KnockOutMatch[t].Phase:='Round of 16';
        end;
    'Quarter Final' : begin
         KnockOutMatch[t-p].Phase:='Quarter Final';
         KnockOutMatch[t].Phase:='Quarter Final';
        end;
    'Semifinal' : begin
         KnockOutMatch[t-p].Phase:='Semifinal';
         KnockOutMatch[t].Phase:='Semifinal';
        end;
        end;



      if (KnockOutMatch[t-p].Home_Team=Participant.MyTeam_ID) then
       begin
        Participant.MyTeam_Match[my].Match_ID:=t-p;
        Participant.MyTeam_Match[my+1].Match_ID:=t;
        Participant.MyTeam_Match[my].Status:='Home';
        Participant.MyTeam_Match[my+1].Status:='Away';
       end
      else if (KnockOutMatch[t-p].Away_Team=Participant.MyTeam_ID) then
       begin
        Participant.MyTeam_Match[my].Match_ID:=t-p;
        Participant.MyTeam_Match[my+1].Match_ID:=t;
        Participant.MyTeam_Match[my].Status:='Away';
        Participant.MyTeam_Match[my+1].Status:='Home';
       end;        

      KnockOutMatch[t-p].Matchday:=1;
      KnockOutMatch[t-p].Venue:=Club[KnockOutMatch[t-p].Home_Team].Home_Stadium;            

      KnockOutMatch[t].Matchday:=2;
      KnockOutMatch[t].Home_Team:=KnockOutMatch[t-p].Away_Team;
      KnockOutMatch[t].Away_Team:=KnockOutMatch[t-p].Home_Team;      
      KnockOutMatch[t].Venue:=Club[KnockOutMatch[t].Home_Team].Home_Stadium;      
    end;
    skip:   
  end;

  function Check_Qualified(locate:string;myteamid:integer):boolean;
   var
    i:integer;
    qualify:boolean;
   begin
    case (locate) of
    'Round of 16' : begin
         i:=7;
        end;
    'Quarter Final' : begin
         i:=9;
        end;
    'Semifinal' : begin
         i:=11;
        end;
    'Final' : begin
         i:=13;
        end;
    end;
    qualify:=(Participant.MyTeam_Match[i].Match_ID<>0);
    Check_Qualified:=qualify;
  end; 


  procedure View_KnockOut_Draw(locate:string);
   var
    m,r,line:integer;
   begin
    clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');


    case (locate) of
    'Round of 16' : begin
   gotoxy(73,6); write('====================');
   gotoxy(73,7); write('| ROUND OF 16 DRAW |');
   gotoxy(73,8); write('====================');
         m:=1;
         r:=8;

        end;
    'Quarter Final' : begin
   gotoxy(71,6); write('======================');
   gotoxy(71,7); write('| QUARTER FINAL DRAW |');
   gotoxy(71,8); write('======================');
         m:=17;
         r:=20;
        
        end;
    'Semifinal' : begin
   gotoxy(72,6); write('==================');
   gotoxy(72,7); write('| SEMIFINAL DRAW |');
   gotoxy(72,8); write('==================');
         m:=25;
         r:=26;
         
        end;
    'Final' : begin
   gotoxy(68,6); write('===============================');
   gotoxy(68,7); write('| UEFA CHAMPIONS LEAGUE FINAL |');
   gotoxy(68,8); write('===============================');
         m:=29;
         r:=29;        
        end;
    end;
    gotoxy(58,10); write('================================================');

    line:=11;
    while (m<=r) do
     begin         
      gotoxy(58,line); write('| ',Club[KnockOutMatch[m].Home_Team].Team_Name,' vs ',Club[KnockOutMatch[m].Away_Team].Team_Name); gotoxy(105,line); write('|');
      line:=line+1;
      m:=m+1;
     end;
    gotoxy(58,line); write('================================================');
    gotoxy(67,line+2); write('Press Enter to Continue...');     
     readln;
    end;

  procedure View_KnockOut_Match(locate:string;leg:integer);
   var
    m,t,r,line:integer;
   begin
    clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

    case (locate) of
    'Round of 16' : begin
   gotoxy(73,6); write('=====================');
   gotoxy(73,7); write('| ROUND OF 16 LEG ',leg,' |');
   gotoxy(73,8); write('=====================');
         m:=1;
         t:=8;
         r:=8;
        end;
    'Quarter Final' : begin
   gotoxy(71,6); write('=======================');
   gotoxy(71,7); write('| QUARTER FINAL LEG ',leg,' |');
   gotoxy(71,8); write('=======================');
         m:=17;
         t:=4;
         r:=20;
        end;
    'Semifinal' : begin
   gotoxy(72,6); write('===================');
   gotoxy(72,7); write('| SEMIFINAL LEG ',leg,' |');
   gotoxy(72,8); write('===================');
         m:=25;
         t:=2;
         r:=26;
        end;
    'Final' : begin
    gotoxy(59,6); write('===============================================');
   gotoxy(59,7); write('| UEFA CHAMPIONS LEAGUE FINAL ',UpCase(Club[Final_Host].City)); gotoxy(105,7); write('|'); 
   gotoxy(59,8); write('===============================================');
         m:=29;
         r:=29;
        end;
    end;
    
    line:=10;
    while (m<=r) do
     begin
      if (leg=1) then
       begin
        gotoxy(58,line); write('================================================');
        gotoxy(58,line+1); write('| ',Club[KnockOutMatch[m].Home_Team].Team_Name,' - ',Club[KnockOutMatch[m].Away_Team].Team_Name); gotoxy(105,line+1); write('|');
        gotoxy(58,line+2); write('| Venue : ',KnockOutMatch[m].Venue); gotoxy(105,line+2); write('|');
        gotoxy(58,line+3); write('================================================');
        line:=line+6;
       end
      else
       begin
        gotoxy(58,line); write('================================================');
        gotoxy(58,line+1); write('| ',Club[KnockOutMatch[m+t].Home_Team].Team_Name,' - ',Club[KnockOutMatch[m+t].Away_Team].Team_Name); gotoxy(105,line+1); write('|');
        gotoxy(58,line+2); write('| Venue : ',KnockOutMatch[m+t].Venue); gotoxy(105,line+3); write('|');
        gotoxy(58,line+3); write('| Aggregate : ',KnockOutMatch[m+t].Home_Agg,' - ',KnockOutMatch[m+t].Away_Agg); gotoxy(105,line+2); write('|');        
        gotoxy(58,line+4); write('================================================');
        line:=line+7;
       end;       
      m:=m+1;
     end;
    gotoxy(67,line+2); write('Press Enter to Continue...');  
    readln;
  end;

 procedure Simulate_KnockOut_Match(locate:string;leg:integer);
  label
   skip;
   var
    m,t,r:integer;
   begin
    case (locate) of
    'Round of 16' : begin
         m:=1;
         t:=8;
         r:=8;
        end;
    'Quarter Final' : begin
         m:=17;
         t:=4;
         r:=20;
        end;
    'Semifinal' : begin
         m:=25;
         t:=2;
         r:=26;
        end;
    'Final' : begin
         m:=29;
         repeat
          KnockOutMatch[m].Home_Score:=random(7);
          KnockOutMatch[m].Away_Score:=random(7);
          KnockOutMatch[29].Home_Pen:=random(8);
          KnockOutMatch[29].Away_Pen:=random(8);
         until (KnockOutMatch[29].Home_Pen<>KnockOutMatch[29].Away_Pen);        
        end;
    end;

    randomize;
    while (m<=r) do
     begin
      if (leg=1) then
       begin
        KnockOutMatch[m].Home_Score:=random(7);
        KnockOutMatch[m].Away_Score:=random(7);

        Club[KnockOutMatch[m].Home_Team].Played:=Club[KnockOutMatch[m].Home_Team].Played+1;
        Club[KnockOutMatch[m].Home_Team].Goals_Scored:=Club[KnockOutMatch[m].Home_Team].Goals_Scored+KnockOutMatch[m].Home_Score;
        Club[KnockOutMatch[m].Home_Team].Goals_Conceded:=Club[KnockOutMatch[m].Home_Team].Goals_Conceded+KnockOutMatch[m].Away_Score;        

        Club[KnockOutMatch[m].Away_Team].Played:=Club[KnockOutMatch[m].Away_Team].Played+1;
        Club[KnockOutMatch[m].Away_Team].Goals_Scored:=Club[KnockOutMatch[m].Away_Team].Goals_Scored+KnockOutMatch[m].Away_Score;
        Club[KnockOutMatch[m].Away_Team].Goals_Conceded:=Club[KnockOutMatch[m].Away_Team].Goals_Conceded+KnockOutMatch[m].Home_Score;

        if (KnockOutMatch[m].Home_Score>KnockOutMatch[m].Away_Score) then
         begin
          Club[KnockOutMatch[m].Home_Team].Wins:=Club[KnockOutMatch[m].Home_Team].Wins+1;
          Club[KnockOutMatch[m].Away_Team].Losses:=Club[KnockOutMatch[m].Away_Team].Losses+1;
         end
        else if (KnockOutMatch[m].Home_Score<KnockOutMatch[m].Away_Score) then
         begin
          Club[KnockOutMatch[m].Home_Team].Losses:=Club[KnockOutMatch[m].Home_Team].Losses+1;
          Club[KnockOutMatch[m].Away_Team].Wins:=Club[KnockOutMatch[m].Away_Team].Wins+1;
         end
        else if (KnockOutMatch[m].Home_Score=KnockOutMatch[m].Away_Score) then
         begin
          Club[KnockOutMatch[m].Home_Team].Draws:=Club[KnockOutMatch[m].Home_Team].Draws+1;
          Club[KnockOutMatch[m].Away_Team].Draws:=Club[KnockOutMatch[m].Away_Team].Draws+1;
         end;

        if (KnockOutMatch[m].Home_Score=0) then
         begin
          Club[KnockOutMatch[m].Home_Team].Cleansheet:=Club[KnockOutMatch[m].Home_Team].Cleansheet+1;
         end;
        if (KnockOutMatch[m].Away_Score=0) then
         begin
          Club[KnockOutMatch[m].Away_Team].Cleansheet:=Club[KnockOutMatch[m].Away_Team].Cleansheet+1;
         end;                                      
        
        if (m<>29) then
         begin
          KnockOutMatch[m+t].Away_Agg:=KnockOutMatch[m].Home_Score;
          KnockOutMatch[m+t].Home_Agg:=KnockOutMatch[m].Away_Score;
         end;
       end
      else if (leg=2) then
       begin
        KnockOutMatch[m+t].Home_Score:=random(7);
        KnockOutMatch[m+t].Home_Agg:=KnockOutMatch[m+t].Home_Agg+KnockOutMatch[m+t].Home_Score;
        KnockOutMatch[m+t].Away_Score:=random(7);
        KnockOutMatch[m+t].Away_Agg:=KnockOutMatch[m+t].Away_Agg+KnockOutMatch[m+t].Away_Score;

        Club[KnockOutMatch[m+t].Home_Team].Played:=Club[KnockOutMatch[m+t].Home_Team].Played+1;
        Club[KnockOutMatch[m+t].Home_Team].Goals_Scored:=Club[KnockOutMatch[m+t].Home_Team].Goals_Scored+KnockOutMatch[m+t].Home_Score;
        Club[KnockOutMatch[m+t].Home_Team].Goals_Conceded:=Club[KnockOutMatch[m+t].Home_Team].Goals_Conceded+KnockOutMatch[m+t].Away_Score;        

        Club[KnockOutMatch[m+t].Away_Team].Played:=Club[KnockOutMatch[m+t].Away_Team].Played+1;
        Club[KnockOutMatch[m+t].Away_Team].Goals_Scored:=Club[KnockOutMatch[m+t].Away_Team].Goals_Scored+KnockOutMatch[m+t].Away_Score;
        Club[KnockOutMatch[m+t].Away_Team].Goals_Conceded:=Club[KnockOutMatch[m+t].Away_Team].Goals_Conceded+KnockOutMatch[m+t].Home_Score;

        if (KnockOutMatch[m+t].Home_Score>KnockOutMatch[m+t].Away_Score) then
         begin
          Club[KnockOutMatch[m+t].Home_Team].Wins:=Club[KnockOutMatch[m+t].Home_Team].Wins+1;
          Club[KnockOutMatch[m+t].Away_Team].Losses:=Club[KnockOutMatch[m+t].Away_Team].Losses+1;
         end
        else if (KnockOutMatch[m+t].Home_Score<KnockOutMatch[m+t].Away_Score) then
         begin
          Club[KnockOutMatch[m+t].Home_Team].Losses:=Club[KnockOutMatch[m+t].Home_Team].Losses+1;
          Club[KnockOutMatch[m+t].Away_Team].Wins:=Club[KnockOutMatch[m+t].Away_Team].Wins+1;
         end
        else if (KnockOutMatch[m+t].Home_Score=KnockOutMatch[m+t].Away_Score) then
         begin
          Club[KnockOutMatch[m+t].Home_Team].Draws:=Club[KnockOutMatch[m+t].Home_Team].Draws+1;
          Club[KnockOutMatch[m+t].Away_Team].Draws:=Club[KnockOutMatch[m+t].Away_Team].Draws+1;
         end;

        if (KnockOutMatch[m+t].Home_Score=0) then
         begin
          Club[KnockOutMatch[m+t].Home_Team].Cleansheet:=Club[KnockOutMatch[m+t].Home_Team].Cleansheet+1;
         end;
        if (KnockOutMatch[m+t].Away_Score=0) then
         begin
          Club[KnockOutMatch[m+t].Away_Team].Cleansheet:=Club[KnockOutMatch[m+t].Away_Team].Cleansheet+1;
         end;

        if (KnockOutMatch[m+t].Home_Agg=KnockOutMatch[m+t].Away_Agg) then
         begin
          repeat
           KnockOutMatch[m+t].Home_Pen:=random(8);
           KnockOutMatch[m+t].Away_Pen:=random(8);
          until (KnockOutMatch[m+t].Home_Pen<>KnockOutMatch[m+t].Away_Pen);
         end;
       end;       
      m:=m+1;
     end;
     skip:
    end;

  function Knock_Out_Match_Winner(locate:string;leg,m,t:integer):string;
   begin
    if (locate='Final') AND (KnockOutMatch[m].Home_Score>KnockOutMatch[m].Away_Score) then
     begin
      Knock_Out_Match_Winner:='1_'+inttostr(KnockOutMatch[m].Home_Team);
     end
    else if (locate='Final') AND (KnockOutMatch[m].Home_Score<KnockOutMatch[m].Away_Score) then
     begin
      Knock_Out_Match_Winner:='1_'+inttostr(KnockOutMatch[m].Away_Team);
     end
    else if (locate='Final') AND ((KnockOutMatch[m].Home_Score=KnockOutMatch[m].Away_Score) AND (KnockOutMatch[m].Home_Pen>KnockOutMatch[m].Away_Pen)) then
     begin
      Knock_Out_Match_Winner:='2_'+inttostr(KnockOutMatch[m].Home_Team);
     end
    else if (locate='Final') AND ((KnockOutMatch[m].Home_Score=KnockOutMatch[m].Away_Score) AND (KnockOutMatch[m].Home_Pen<KnockOutMatch[m].Away_Pen)) then
     begin
      Knock_Out_Match_Winner:='2_'+inttostr(KnockOutMatch[m].Away_Team);
     end   
    else if (KnockOutMatch[m+t].Home_Agg>KnockOutMatch[m+t].Away_Agg) then
     begin
      Knock_Out_Match_Winner:='1_'+(inttostr(KnockOutMatch[m+t].Home_Team));
     end
    else if (KnockOutMatch[m+t].Home_Agg=KnockOutMatch[m+t].Away_Agg) AND (KnockOutMatch[m].Away_Score>KnockOutMatch[m+t].Away_Score) then
     begin
      Knock_Out_Match_Winner:='2_'+(inttostr(KnockOutMatch[m+t].Home_Team)); 
     end
    else if (KnockOutMatch[m+t].Home_Agg=KnockOutMatch[m+t].Away_Agg) AND (KnockOutMatch[m+t].Home_Pen>KnockOutMatch[m+t].Away_Pen) then
     begin
      Knock_Out_Match_Winner:='3_'+(inttostr(KnockOutMatch[m+t].Home_Team));   
     end     
    else if (KnockOutMatch[m+t].Home_Agg<KnockOutMatch[m+t].Away_Agg) then
     begin
      Knock_Out_Match_Winner:='1_'+(inttostr(KnockOutMatch[m+t].Away_Team));
     end
    else if (KnockOutMatch[m+t].Home_Agg=KnockOutMatch[m+t].Away_Agg) AND (KnockOutMatch[m+t].Away_Score>KnockOutMatch[m].Away_Score) then
     begin
      Knock_Out_Match_Winner:='2_'+(inttostr(KnockOutMatch[m+t].Away_Team));    
     end
    else if (KnockOutMatch[m+t].Home_Agg=KnockOutMatch[m+t].Away_Agg) AND (KnockOutMatch[m+t].Home_Pen<KnockOutMatch[m+t].Away_Pen) then
     begin
      Knock_Out_Match_Winner:='3_'+(inttostr(KnockOutMatch[m+t].Away_Team));
     end;
   end;        



  procedure View_KnockOut_Match_Results(locate,command:string;leg:integer);
   var
    m,t,r,i,line:integer;
    winner:string;
   begin
    clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');    
    case (locate) of
    'Round of 16' : begin
         gotoxy(73,6); write('=====================');
         gotoxy(73,7); write('| ROUND OF 16 LEG ',leg,' |');
         gotoxy(73,8); write('=====================');
         m:=1;
         t:=8;
         r:=8;
        end;
    'Quarter Final' : begin
       gotoxy(71,6); write('=======================');
       gotoxy(71,7); write('| QUARTER FINAL LEG ',leg,' |');
       gotoxy(71,8); write('=======================');
         m:=17;
         t:=4;
         r:=20;
        end;
    'Semifinal' : begin
  gotoxy(72,6); write('===================');
   gotoxy(72,7); write('| SEMIFINAL LEG ',leg,' |');
   gotoxy(72,8); write('===================');
         m:=25;
         t:=2;
         r:=26;
        end;
    'Final' : begin
    gotoxy(59,6); write('================================================');
   gotoxy(59,7); write('| UEFA CHAMPIONS LEAGUE FINAL ',UpCase(Club[Final_Host].City)); gotoxy(106,7); write('|'); 
   gotoxy(59,8); write('================================================');
         m:=29;
         r:=29;
        end;    
    end;
    line:=10;

    i:=1;
    while (m<=r) do
     begin
        if (KnockOutMatch[m].Home_Team=0) OR (KnockOutMatch[m].Away_Team=0) then
         begin
        gotoxy(59,line); write('================================================');
        gotoxy(59,line+1); write('|                  TBD - TBD                   |');         
          if (locate='Final') then
           begin
            gotoxy(59,line+2); write('| Venue : ',Club[Final_Host].Home_Stadium); gotoxy(106,line+2); write('|');
           end
          else
           begin
            gotoxy(59,line+2); write('| Venue : TBD'); gotoxy(106,line+2); write('|');
           end;
          gotoxy(59,line+3); write('================================================');
          line:=line+6;
         end
        else
         begin     
      if (leg=1) then
       begin
        gotoxy(58,line); write('=================================================');
        gotoxy(58,line+1); write('| ',Club[KnockOutMatch[m].Home_Team].Team_Name,' ',KnockOutMatch[m].Home_Score,' - ',KnockOutMatch[m].Away_Score,' ',Club[KnockOutMatch[m].Away_Team].Team_Name); gotoxy(106,line+1); write('|');
        gotoxy(58,line+2); write('| Venue : ',KnockOutMatch[m].Venue); gotoxy(106,line+2); write('|');
        gotoxy(58,line+3); write('|'); gotoxy(106,line+3); write('|');
       

        if (locate='Final') then
         begin
          if (command='Simulate') then
           begin
          winner:=Knock_Out_Match_Winner(locate,leg,m,t);
          Champions:=strtoint(copy(winner,3,2));
          if (winner[1]='2') then
           begin
            KnockOutMatch[m].Status:=Club[strtoint(copy(winner,3,2))].Team_Name+' win by Penalties ('+inttostr(KnockOutMatch[m].Home_Pen)+' - '+inttostr(KnockOutMatch[m].Away_Pen)+')';            
           end;
           end;
          gotoxy(58,line+3); write('| ',KnockOutMatch[m].Status); gotoxy(106,line+3); write('|');
         end;

        gotoxy(58,line+4); write('=================================================');
        line:=line+7; 
       end
      else if (leg=2) then
       begin
        gotoxy(58,line); write('=================================================');        
        gotoxy(58,line+1); write('| ',Club[KnockOutMatch[m+t].Home_Team].Team_Name,' ',KnockOutMatch[m+t].Home_Score,' - ',KnockOutMatch[m+t].Away_Score,' ',Club[KnockOutMatch[m+t].Away_Team].Team_Name); gotoxy(106,line+1); write('|');
        gotoxy(58,line+2); write('| Venue : ',KnockOutMatch[m+t].Venue); gotoxy(106,line+2); write('|');      
        gotoxy(58,line+3); write('| Aggregate : ',KnockOutMatch[m+t].Home_Agg,' - ',KnockOutMatch[m+t].Away_Agg); gotoxy(106,line+3); write('|');
        if (command='Simulate') then
         begin
        winner:=Knock_Out_Match_Winner(locate,leg,m,t);      
        case (winner[1]) of
        '1' : begin
               KnockOutMatch[m+t].Status:=Club[strtoint(copy(winner,3,2))].Team_Name+' win by Aggregate';
              end;               
        '2' : begin
               KnockOutMatch[m+t].Status:=Club[strtoint(copy(winner,3,2))].Team_Name+' win by Away Goal ('+inttostr(KnockOutMatch[m].Away_Score)+' - '+inttostr(KnockOutMatch[m+t].Away_Score)+')';
              end;               
        '3' : begin
               KnockOutMatch[m+t].Status:=Club[strtoint(copy(winner,3,2))].Team_Name+' win by Penalties ('+inttostr(KnockOutMatch[m+t].Home_Pen)+' - '+inttostr(KnockOutMatch[m+t].Away_Pen)+')';
              end;               
        end;  
          Pot[i]:=strtoint(copy(winner,3,2));
          i:=i+1;
        end;
       gotoxy(58,line+4); write('| ',KnockOutMatch[m+t].Status); gotoxy(106,line+4); write('|');
       gotoxy(58,line+5); write('=================================================');
       line:=line+8;         
       end;
       end;       
      m:=m+1;
     end;
      gotoxy(70,line+1); write('Press Enter to Continue...');
      readln;
    end;

  procedure Show_Champions;
   begin
    clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(56,6); write('======================================================');
   gotoxy(56,7); write('| ',Club[Champions].Club_Name); gotoxy(109,7); write('|');
   gotoxy(56,8); write('| ',UpCase(Club[Champions].Team_Name),' (',Club[Champions].Country,')'); gotoxy(109,8); write('|');
   gotoxy(56,9); write('| UEFA CHAMPIONS LEAGUE WINNER'); gotoxy(109,9); write('|');
   gotoxy(56,10); write('======================================================');

   gotoxy(67,12); write('Press Enter to Continue...');   
   readln;
   end;

 procedure Set_Defaults;
  var
   g,i:integer;
  begin
   for g:=1 to 8 do
    begin
     for i:=1 to 4 do
      begin
       Group[g,i].Played:=0;
       Group[g,i].Win:=0;
       Group[g,i].Draw:=0;
       Group[g,i].Loss:=0;
       Group[g,i].Goals_Scored:=0;
       Group[g,i].Goals_Conceded:=0;
       Group[g,i].Goals_Difference:=0;
       Group[g,i].Points:=0;
       GroupRankings[g,i]:=0;  
      end;
    end;

   for g:=1 to 8 do
    begin
     for i:=1 to 12 do
      begin
       Match[g,i].Home_Score:=0;    
       Match[g,i].Away_Score:=0;   
       Match[g,i].Venue:='';  
      end;
    end;    

   for i:=1 to 29 do
    begin
     KnockOutMatch[i].Home_Team:=0;
     KnockOutMatch[i].Away_Team:=0;
     KnockOutMatch[i].Home_Score:=0;   
     KnockOutMatch[i].Home_Agg:=0;     
     KnockOutMatch[i].Home_Pen:=0; 
     KnockOutMatch[i].Away_Score:=0;
     KnockOutMatch[i].Away_Agg:=0;
     KnockOutMatch[i].Away_Pen:=0;   
     KnockOutMatch[i].Venue:='';
     KnockOutMatch[i].Status:='';
    end;

   for i:=1 to 13 do
    begin
     Participant.MyTeam_Match[i].Match_ID:=0;
    end;

   for i:=1 to 64 do
    begin
     Club[i].Played:=0;
     Club[i].Wins:=0;
     Club[i].Draws:=0;
     Club[i].Losses:=0;
     Club[i].Goals_Scored:=0;
     Club[i].Goals_Conceded:=0;
     Club[i].Cleansheet:=0;
    end;

    for i:=1 to 32 do
     begin
      Pot[i]:=0;
      Participant.ParticipantArray[i]:=0;
     end;

   Final_Host:=0;
   Champions:=0;
   Stats.Most_Wins:=0;
   Stats.Most_Draws:=0;
   Stats.Most_Losses:=0;
   Stats.Best_Attack:=0;
   Stats.Best_Defence:=0;
   Stats.Poor_Attack:=0;
   Stats.Poor_Defence:=0;
   Stats.Most_Cleansheet:=0;
  end;     


 procedure Menu_Data;
  label
   goback;
  var
   i,n,menu:integer;
   command,input:string;
  begin
   n:=32;
   goback:
   clrscr;
   writeln;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(75,6); write('=================');
   gotoxy(75,7); write('| TEAM DATABASE |');
   gotoxy(75,8); write('=================');

   gotoxy(2,9); writeln('======================================================================================================================================================================='); 
   gotoxy(2,10); write('|'); gotoxy(77,10); write('ALL TEAMS DATA'); gotoxy(168,10); write('|');
   gotoxy(2,11); writeln('======================================================================================================================================================================='); 
   gotoxy(2,12); write('| No ');
   gotoxy(7,12); write('|'); gotoxy(15,12); write('Team Name');
   gotoxy(29,12); write('|'); gotoxy(50,12); write('Club Name');
   gotoxy(79,12); write('|'); gotoxy(84,12); write('Country');
   gotoxy(95,12); write('|'); gotoxy(105,12); write('Home Stadium');
   gotoxy(126,12); write('|'); gotoxy(137,12); write('Manager');
   gotoxy(152,12); write('|'); gotoxy(154,12); write('Titles');
   gotoxy(161,12); write('|'); gotoxy(162,12); write('Group |');
   gotoxy(2,13); writeln('=======================================================================================================================================================================');                    
   for i:=1 to n do
    begin
     gotoxy(2,i+13); write('| ',i);
     gotoxy(7,i+13); write('| ',Club[Participant.ParticipantArray[i]].Team_Name);
     gotoxy(29,i+13); write('| ',Club[Participant.ParticipantArray[i]].Club_Name);
     gotoxy(79,i+13); write('| ',Club[Participant.ParticipantArray[i]].Country);
     gotoxy(95,i+13); write('| ',Club[Participant.ParticipantArray[i]].Home_Stadium);
     gotoxy(126,i+13); write('| ',Club[Participant.ParticipantArray[i]].Manager);
     gotoxy(152,i+13); write('|   ',Club[Participant.ParticipantArray[i]].Titles);
     gotoxy(161,i+13); write('|   ',Club[Participant.ParticipantArray[i]].Group,'  |');
    end;
   gotoxy(2,i+14); writeln('======================================================================================================================================================================='); 
   gotoxy(45,i+15); write('============================================================================');
   gotoxy(45,i+16); write('| 1.Search     2.Sort      3.Filter     4.Show All     5.Back to Main Menu |');
   gotoxy(45,i+17); write('============================================================================');
    gotoxy(75,i+18); write('* Select Menu : '); readln(menu);
    if (menu<1) OR (menu>5) then
     begin
      gotoxy(68,i+21); write('* Message :');
      gotoxy(68,i+22); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo goback;
     end;
   case (menu) of
   1 : begin
        gotoxy(75,i+21); write('=====================');
        gotoxy(75,i+22); write('|    SEARCH DATA    |');
        gotoxy(75,i+23); write('| 1. Team Name      |');
        gotoxy(75,i+24); write('| 2. Manager`s Name |');
        gotoxy(75,i+25); write('| 3. Home Stadium   |');
        gotoxy(75,i+26); write('=====================');
        gotoxy(75,i+27); write('* Search by :'); readln(menu);
      if (menu<1) OR (menu>3) then
     begin
      gotoxy(68,i+29); write('* Message :');
      gotoxy(68,i+30); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo goback;
     end;       
        case (menu) of
          1 : command:='Team';
          2 : command:='Manager';
          3 : command:='Stadium';
         end; 
        gotoxy(72,i+29); write('Search ' ,command,' : '); readln(input);
        if Search_Data(input,command) then
         begin
          n:=1;
          gotoxy(68,i+31); write('Data found! Press Enter to Show...');
         end
        else
         begin
          n:=32;
          gotoxy(68,i+31); write('Data not found! Press Enter to Continue...');
         end;
        readln;
        GoTo goback;
       end;
   2 : begin
        gotoxy(73,i+21); write('==============================');
        gotoxy(73,i+22); write('|          SORT DATA         |');
        gotoxy(73,i+23); write('| 1. A-Z                     |');
        gotoxy(73,i+24); write('| 2. Z-A                     |');
        gotoxy(73,i+25); write('| 3. Champions League Titles |');
        gotoxy(73,i+26); write('==============================');
        gotoxy(73,i+27); write('* Sort by : '); readln(menu);
      if (menu<1) OR (menu>3) then
     begin
      gotoxy(68,i+29); write('* Message :');
      gotoxy(68,i+30); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo goback;
     end;         
        case (menu) of
        1 : command:='Ascending';
        2 : command:='Descending';
        3 : command:='Titles';        
        end;
        Sorting_Data(command,n);
       end;
    3 : begin
         gotoxy(75,i+21); write('==================');
         gotoxy(75,i+22); write('|   FILTER DATA  |');
         gotoxy(75,i+23); write('| 1. Country     |');
         gotoxy(75,i+24); write('| 2. Group       |');
         gotoxy(75,i+25); write('==================');
         gotoxy(75,i+26); write('* Filter by : '); readln(menu);
      if (menu<1) OR (menu>2) then
     begin
      gotoxy(68,i+28); write('* Message :');
      gotoxy(68,i+29); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo goback;
     end;           
         case (menu) of
         1 : begin
              command:='Country';
              gotoxy(60,i+28); write('=========================================================');
              gotoxy(60,i+29); write('|                    FILTER BY COUNTRY                  |');
              gotoxy(60,i+30); write('| 1. England       9. Belgium        17. Sweden         |');
              gotoxy(60,i+31); write('| 2. Spain         10. Switzerland   18. Serbia         |');
              gotoxy(60,i+32); write('| 3. Italy         11. Austria       19. Denmark        |');
              gotoxy(60,i+33); write('| 4. Germany       12. Ukraine       20. Croatia        |');
              gotoxy(60,i+34); write('| 5. France        13. Poland        21. Norway         |');
              gotoxy(60,i+35); write('| 6. Portugal      14. Russia        22. Romania        |');
              gotoxy(60,i+36); write('| 7. Netherlands   15. Greece        23. Cyprus         |');
              gotoxy(60,i+37); write('| 8. Scotland      16. Turkey        24. Czech Republic |');
              gotoxy(60,i+38); write('=========================================================');
              gotoxy(60,i+39); write('* Filter by Country : '); readln(menu);
              if (menu<1) OR (menu>24) then
               begin
                gotoxy(68,i+41); write('* Message :');
                gotoxy(68,i+42); write('- Wrong menu input, please input menu correctly!');
                readln;
                GoTo goback;
               end;    
              case (menu) of
              1 : input:='England';
              2 : input:='Spain'; 
              3 : input:='Italy';    
              4 : input:='Germany';     
              5 : input:='France';        
              6 : input:='Portugal';  
              7 : input:='Netherlands'; 
              8 : input:='Scotland';
              9 : input:='Belgium';
              10 : input:='Switzerland';
              11 : input:='Austria';
              12 : input:='Ukraine';
              13 : input:='Poland';
              14 : input:='Russia';
              15 : input:='Greece';
              16 : input:='Turkey';
              17 : input:='Sweden';
              18 : input:='Serbia';
              19 : input:='Denmark';
              20 : input:='Croatia';
              21 : input:='Norway';
              22 : input:='Romania';
              23 : input:='Cyprus';
              24 : input:='Czech Republic';
              end;
            end;
        2 : begin
             command:='Group';
             gotoxy(69,i+28); write('================================');
             gotoxy(69,i+29); write('|        FILTER BY GROUP       |');
             gotoxy(69,i+30); write('| 1. Group A        5. Group E |');
             gotoxy(69,i+31); write('| 2. Group B        6. Group F |');
             gotoxy(69,i+32); write('| 3. Group C        7. Group G |');
             gotoxy(69,i+33); write('| 4. Group D        8. Group H |');
             gotoxy(69,i+34); write('================================');
             gotoxy(69,i+35); write('* Filter by Group : '); readln(menu);
             if (menu<1) OR (menu>8) then
               begin
                gotoxy(68,i+37); write('* Message :');
                gotoxy(68,i+38); write('- Wrong menu input, please input menu correctly!');
                readln;
                GoTo goback;
               end;
             input:=chr(menu+64);           
            end;
          end;
        Filter_Data(input,command,n);
        end;                                                                                                                                                                                                                         
    4 : n:=32;
    5 : Exit;
   end;
   GoTo goback;
  end;  

 procedure Menu_Stats(locate:string);
  label
   goback,tab_stats,tab_fixtures,tab_teams,showagain;
  var
   command:string;
   g,i,n,line:integer;
  begin
   goback:
   clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(72,6); write('========================');
   gotoxy(72,7); write('|       STATS MENU     |');
   gotoxy(72,8); write('| 1. My Team Stats     |');
   gotoxy(72,9); write('| 2. Team Stats        |');
   gotoxy(72,10); write('| 3. Match Stats       |');
   gotoxy(72,11); write('| 4. Back to Main Menu |');
   gotoxy(72,12); write('========================');
   gotoxy(72,13); write('* Select Menu : '); readln(menu);
   if (menu<1) OR (menu>4) then
    begin
     gotoxy(68,15); write('* Message :');
     gotoxy(68,16); write('- Wrong menu input, please input menu correctly!');
     readln;
     GoTo goback;
    end;
   case (menu) of
   1 : begin
        clrscr;
        gotoxy(67,2); write('=================================');
        gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
        gotoxy(67,4); write('=================================');

        gotoxy(76,6); write('=================');
        gotoxy(76,7); write('| MY TEAM STATS |');
        gotoxy(76,8); write('=================');  
      
        gotoxy(62,10); write('=============================================');
        gotoxy(62,11); write('|'); gotoxy(74,11); write(UpCase(Club[Participant.MyTeam_ID].Team_Name),' (',Club[Participant.MyTeam_ID].Country,')'); gotoxy(106,11); write('|');
        gotoxy(62,12); write('|'); gotoxy(78,12); write(Club[Participant.MyTeam_ID].Manager); gotoxy(106,12); write('|');
        gotoxy(62,13); write('|                  Group ',chr(64+Participant.MyTeam_Group)); gotoxy(106,13); write('|');
        gotoxy(62,14); write('=============================================');

        gotoxy(65,16); write('=====================================');
        gotoxy(65,17); write('|           YOUR TEAM STATS :       |');
        gotoxy(65,18); write('| Match Played : ',Club[Participant.MyTeam_ID].Played); gotoxy(101,18); write('|');
        gotoxy(65,19); write('| Win : ',Club[Participant.MyTeam_ID].Wins); gotoxy(101,19); write('|');
        gotoxy(65,20); write('| Draw : ',Club[Participant.MyTeam_ID].Draws); gotoxy(101,20); write('|');
        gotoxy(65,21); write('| Loss : ',Club[Participant.MyTeam_ID].Losses); gotoxy(101,21); write('|');
        gotoxy(65,22); write('| Goals Scored : ',Club[Participant.MyTeam_ID].Goals_Scored); gotoxy(101,22); write('|');
        gotoxy(65,23); write('| Goals Conceded : ',Club[Participant.MyTeam_ID].Goals_Conceded); gotoxy(101,23); write('|');
        gotoxy(65,24); write('| Cleansheet : ',Club[Participant.MyTeam_ID].Cleansheet); gotoxy(101,24); write('|');
        gotoxy(65,25); write('=====================================');

        gotoxy(58,27); write('======================================================');
        gotoxy(58,28); write('|           YOUR MATCH SCHEDULE & RESULTS:           |');
        gotoxy(58,29); write('======================================================');
        line:=30;
        for i:=1 to 6 do
         begin
          gotoxy(58,line); write('| ',Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Phase,' Matchday ',Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Matchday); gotoxy(111,line); write('|');
          gotoxy(58,line+1); write('| ',Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Home_Team].Team_Name,' ',Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Home_Score,' - ',Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Away_Score,' ',Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Away_Team].Team_Name); gotoxy(111,line+1); write('|');
          gotoxy(58,line+2); write('| Venue : ',Match[Participant.MyTeam_Group,Participant.MyTeam_Match[i].Match_ID].Venue); gotoxy(111,line+2); write('|');
          gotoxy(58,line+3); write('======================================================');
          line:=line+4;
         end;


        i:=7;
        while (i<=13) do
         begin
        if (Participant.MyTeam_Match[i].Match_ID<>0) then
         begin
          if (i=13) then
           begin
          gotoxy(58,line); write('| ',KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Phase); gotoxy(111,line); write('|');
          gotoxy(58,line+1); write('| ',Club[KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Home_Team].Team_Name,' ',KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Home_Score,' - ',KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Away_Score,' ',Club[KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Away_Team].Team_Name); gotoxy(111,line+1); write('|');
          gotoxy(58,line+2); write('| Venue : ',KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Venue); gotoxy(111,line+2); write('|');
          gotoxy(58,line+3); write('| ',KnockOutMatch[Participant.MyTeam_Match[i].Match_ID].Status); gotoxy(111,line+3); write('|');
          gotoxy(111,line+4); write('======================================================');
           end
          else
           begin                     
            for g:=i to i+1 do
             begin
              gotoxy(58,line); write('| ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Phase,' Leg ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Matchday); gotoxy(111,line); write('|');
              gotoxy(58,line+1); write('| ',Club[KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Home_Team].Team_Name,' ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Home_Score,' - ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Away_Score,' ',Club[KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Away_Team].Team_Name); gotoxy(111,line+1); write('|');
              gotoxy(58,line+2); write('| Venue : ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Venue); gotoxy(111,line+2); write('|');
              line:=line+3;
              if (g mod 2=0) then
               begin
              gotoxy(58,line); write('| Aggregate : ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Home_Agg,' - ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Away_Agg); gotoxy(111,line); write('|');
              gotoxy(58,line+1); write('| ',KnockOutMatch[Participant.MyTeam_Match[g].Match_ID].Status); gotoxy(111,line+1); write('|');
              line:=line+2;
              end;
              gotoxy(58,line); write('======================================================');
              line:=line+1;
             end;
            end;
          end;
          i:=i+2;
        end;
     
        gotoxy(75,line+1); write('Press Enter to Back...');
        readln;
        GoTo goback;        
        end;

   2 : begin
        tab_teams:
        clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(72,6); write('========================');
   gotoxy(72,7); write('|       TEAM STATS     |');
   gotoxy(72,8); write('| 1. All Teams Stats   |');
   gotoxy(72,9); write('| 2. Teams Records     |');
   gotoxy(72,10); write('| 3. Back              |');
   gotoxy(72,11); write('========================');
   gotoxy(72,12); write('* Select Menu : '); readln(menu);
   if (menu<1) OR (menu>3) then
    begin
     gotoxy(68,14); write('* Message :');
     gotoxy(68,15); write('- Wrong menu input, please input menu correctly!');
     readln;
     GoTo tab_teams;
    end;
         case (menu) of
         1 : begin
              n:=32;
              showagain:
              clrscr;
              gotoxy(67,2); write('=================================');
              gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
              gotoxy(67,4); write('=================================');

              gotoxy(75,6); write('===================');
              gotoxy(75,7); write('| ALL TEAMS STATS |');
              gotoxy(75,8); write('===================');

   gotoxy(33,10); writeln('======================================================================================================'); 
   gotoxy(33,11); write('| No ');
   gotoxy(38,11); write('|'); gotoxy(46,11); write('Team Name');
   gotoxy(60,11); write('| Played');
   gotoxy(69,11); write('| Win');
   gotoxy(75,11); write('| Draw');
   gotoxy(82,11); write('| Loss');
   gotoxy(89,11); write('| Goals Scored');
   gotoxy(104,11); write('| Goals Conceded');
   gotoxy(121,11); write('| Cleansheet'); gotoxy(134,11); write('|');
   gotoxy(33,12); writeln('======================================================================================================');                    
   for i:=1 to n do
    begin
     gotoxy(33,i+12); write('| ',i);
     gotoxy(38,i+12); write('| ',Club[Participant.ParticipantArray[i]].Team_Name);
     gotoxy(60,i+12); write('|'); gotoxy(64,i+12); write(Club[Participant.ParticipantArray[i]].Played);
     gotoxy(69,i+12); write('|'); gotoxy(72,i+12); write(Club[Participant.ParticipantArray[i]].Wins);
     gotoxy(75,i+12); write('|'); gotoxy(78,i+12); write(Club[Participant.ParticipantArray[i]].Draws);
     gotoxy(82,i+12); write('|'); gotoxy(85,i+12); write(Club[Participant.ParticipantArray[i]].Losses);
     gotoxy(89,i+12); write('|'); gotoxy(95,i+12); write(Club[Participant.ParticipantArray[i]].Goals_Scored);
     gotoxy(104,i+12); write('|'); gotoxy(110,i+12); write(Club[Participant.ParticipantArray[i]].Goals_Conceded);
     gotoxy(121,i+12); write('|'); gotoxy(127,i+12); write(Club[Participant.ParticipantArray[i]].Cleansheet); gotoxy(134,i+12); write('|');
    end;
   gotoxy(33,i+13); writeln('======================================================================================================');
   gotoxy(62,i+15); write('================================================== ');
   gotoxy(62,i+16); write('| 1.Search      2.Sort      3.Show All    4.Back |');
   gotoxy(62,i+17); write('==================================================');
    gotoxy(75,i+18); write('* Select Menu : '); readln(menu);
    if (menu<1) OR (menu>4) then
     begin
      gotoxy(68,i+21); write('* Message :');
      gotoxy(68,i+22); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;
   case (menu) of
   1 : begin
        gotoxy(75,i+20); write('Search Team : '); readln(command);
        if Search_Data(command,'Team') then
         begin
          n:=1;
          gotoxy(68,i+21); write('Data found! Press Enter to Show...');
         end
        else
         begin
          n:=32;
          gotoxy(68,i+21); write('Data not found! Press Enter to Continue...');
         end;
        readln;
        GoTo showagain;
       end;
   2 : begin
        gotoxy(73,i+21); write('==================');
        gotoxy(73,i+22); write('|    SORT DATA   |');
        gotoxy(73,i+23); write('| 1. A-Z         |');
        gotoxy(73,i+24); write('| 2. Z-A         |');
        gotoxy(73,i+25); write('==================');
        gotoxy(73,i+26); write('* Sort by : '); readln(menu);
      if (menu<1) OR (menu>3) then
     begin
      gotoxy(68,i+28); write('* Message :');
      gotoxy(68,i+29); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;  
        case (menu) of
        1 : command:='Ascending';
        2 : command:='Descending';        
        end;
        Sorting_Data(command,32);
        GoTo showagain;
       end;
   3 : begin
        n:=32;
        GoTo showagain;
       end;
   4 : GoTo tab_teams;
    end;
    end;

  2 : begin
       clrscr;
              gotoxy(67,2); write('=================================');
              gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
              gotoxy(67,4); write('=================================');

              gotoxy(76,6); write('=================');
              gotoxy(76,7); write('| TEAMS RECORDS |');
              gotoxy(76,8); write('================='); 
        command:='Most Wins';
        Stats.Most_Wins:=Search_Stats(command);
        gotoxy(40,10); write('=========================================================================================');
        gotoxy(40,11); write('| Team with Most Wins : ',Club[Stats.Most_Wins].Team_Name,' with ',Club[Stats.Most_Wins].Wins,' Wins in ',Club[Stats.Most_Wins].Played,' Matches'); gotoxy(128,11); write('|');

        command:='Most Draws';
        Stats.Most_Draws:=Search_Stats(command);
        gotoxy(40,12); write('| Team with Most Draws : ',Club[Stats.Most_Draws].Team_Name,' with ',Club[Stats.Most_Draws].Draws,' Draws in ',Club[Stats.Most_Draws].Played,' Matches'); gotoxy(128,12); write('|');

        command:='Most Loss';
        Stats.Most_Losses:=Search_Stats(command);
        gotoxy(40,13); write('| Team with Most Losses : ',Club[Stats.Most_Losses].Team_Name,' with ',Club[Stats.Most_Losses].Losses,' Losses in ',Club[Stats.Most_Losses].Played,' Matches'); gotoxy(128,13); write('|');

        command:='Best Attack';
        Stats.Best_Attack:=Search_Stats(command);
        gotoxy(40,14); write('| Team with Best Attack : ',Club[Stats.Best_Attack].Team_Name,' with ',Club[Stats.Best_Attack].Goals_Scored,' Goals Scored in ',Club[Stats.Best_Attack].Played,' Matches'); gotoxy(128,14); write('|');

        command:='Best Defence';
        Stats.Best_Defence:=Search_Stats(command);
        gotoxy(40,15); write('| Team with Best Defence : ',Club[Stats.Best_Defence].Team_Name,' with only ',Club[Stats.Best_Defence].Goals_Conceded,' Goals Conceded in ',Club[Stats.Best_Defence].Played,' Matches'); gotoxy(128,15); write('|');

        command:='Poor Attack';
        Stats.Poor_Attack:=Search_Stats(command);
        gotoxy(40,16); writeln('| Team with Worst Attack : ',Club[Stats.Poor_Attack].Team_Name,' with only ',Club[Stats.Poor_Attack].Goals_Scored,' Goals Scored in ',Club[Stats.Poor_Attack].Played,' Matches'); gotoxy(128,16); write('|');

        command:='Poor Defence';
        Stats.Poor_Defence:=Search_Stats(command);
        gotoxy(40,17); writeln('| Team with Worst Defence : ',Club[Stats.Poor_Defence].Team_Name,' with ',Club[Stats.Poor_Defence].Goals_Conceded,' Goals Conceded in ',Club[Stats.Poor_Defence].Played,' Matches'); gotoxy(128,17); write('|');

        command:='Most Cleansheet';
        Stats.Most_Cleansheet:=Search_Stats(command);
        gotoxy(40,18); writeln('| Team with Most Cleansheet : ',Club[Stats.Most_Cleansheet].Team_Name,' with ',Club[Stats.Most_Cleansheet].Cleansheet,' Cleansheets in ',Club[Stats.Most_Cleansheet].Played,' Matches'); gotoxy(128,18); write('|');
        gotoxy(40,19); write('=========================================================================================');


        gotoxy(74,21); write('Press Enter to Back...');
        readln;
        GoTo tab_teams;
       end;
      3 : GoTo goback;
     end;
     end;
    3 : begin
         tab_stats:
         clrscr;
              gotoxy(67,2); write('=================================');
              gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
              gotoxy(67,4); write('=================================');

   gotoxy(64,6); write('=======================================');
   gotoxy(64,7); write('|              MATCH STATS            |');
   gotoxy(64,8); write('| 1. All Fixtures Schedules & Results |');
   gotoxy(64,9); write('| 2. Group Stage Standings            |');
   gotoxy(64,10); write('| 3. Back                             |');
   gotoxy(64,11); write('=======================================');
   gotoxy(64,12); write('* Select Menu : '); readln(menu);
   if (menu<1) OR (menu>3) then
    begin
     gotoxy(68,14); write('* Message :');
     gotoxy(68,15); write('- Wrong menu input, please input menu correctly!');
     readln;
     GoTo tab_stats;
    end;
         case (menu) of
          1 : begin
               tab_fixtures:
               clrscr;
              gotoxy(67,2); write('=================================');
              gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
              gotoxy(67,4); write('=================================');               

              gotoxy(66,6); write('====================================');
              gotoxy(66,7); write('| ALL FIXTURES SCHEDULES & RESULTS |');
              gotoxy(66,8); write('====================================');

              gotoxy(66,9); write('| 1. Group Stage Matchday 1        |');
              gotoxy(66,10); write('| 2. Group Stage Matchday 2        |');
              gotoxy(66,11); write('| 3. Group Stage Matchday 3        |');
              gotoxy(66,12); write('| 4. Group Stage Matchday 4        |');
              gotoxy(66,13); write('| 5. Group Stage Matchday 5        |');
              gotoxy(66,14); write('| 6. Group Stage Matchday 6        |');
              gotoxy(66,15); write('| 7. Round Of 16 Leg 1             |');
              gotoxy(66,16); write('| 8. Round Of 16 Leg 2             |');
              gotoxy(66,17); write('| 9. Quarter Final Leg 1           |');
              gotoxy(66,18); write('| 10. Quarter Final Leg 2          |');
              gotoxy(66,19); write('| 11. Semifinal Leg 1              |');
              gotoxy(66,20); write('| 12. Semifinal Leg 2              |');
              gotoxy(66,21); write('| 13. Final                        |');
              gotoxy(66,22); write('| 14. Back                         |');
              gotoxy(66,23); write('====================================');               
              gotoxy(66,24); write('* Select Menu : '); readln(menu);
                 if (menu<1) OR (menu>14) then
                  begin
                   gotoxy(68,26); write('* Message :');
                   gotoxy(68,27); write('- Wrong menu input, please input menu correctly!');
                   readln;
                   GoTo tab_fixtures;
                  end;
               if (menu>=1) AND (menu<=6) then
                begin
                 ViewMatchResults('Just Show',menu);
                 GoTo tab_fixtures;
                end
               else if (menu>=7) AND (menu<=13) then
                begin
                 if (menu=7) OR (menu=8) then
                  begin
                   command:='Round of 16';
                  end
                 else if (menu=9) OR (menu=10) then
                  begin
                   command:='Quarter Final';
                  end
                 else if (menu=11) OR (menu=12) then
                  begin
                   command:='Semifinal';
                  end
                 else if (menu=13) then
                  begin
                   command:='Final';
                   menu:=1;
                  end;
                 if (menu=7) OR (menu=9) OR (menu=11) then
                  begin
                   menu:=1;
                  end
                 else if (menu=8) OR (menu=10) OR (menu=12) then
                  begin
                   menu:=2;
                  end;
                 View_KnockOut_Match_Results(command,'Just Show',menu);
                 GoTo tab_fixtures;
                end;
                GoTo tab_stats;
              end;
          2 : begin
               View_Group_Standings;
               GoTo tab_stats;
              end;
          3 : GoTo goback;
          end;
          end;
    4 : exit;
    end;
  end;                                                      


 function MenuManageTeam(var choice:integer;locate:string;my:integer;qualify:boolean):integer;
  label
   showagain;
  begin
   showagain:
   clrscr;
   gotoxy(67,2); write('=================================');
   gotoxy(67,3); write('| UEFA CHAMPIONS LEAGUE FANTASY |');
   gotoxy(67,4); write('=================================');

   gotoxy(76,6); write('=============');
   gotoxy(76,7); write('| MAIN MENU |');
   gotoxy(76,8); write('=============');   

   gotoxy(45,9); write('============================================================================');
   gotoxy(45,10); write('|'); gotoxy(75,10); write(UpCase(Club[Participant.MyTeam_ID].Team_Name)); gotoxy(120,10); write('|');
   gotoxy(45,11); write('|'); gotoxy(77,11); write('(',Club[Participant.MyTeam_ID].Country,')'); gotoxy(120,11); write('|');
   gotoxy(45,12); write('|'); gotoxy(74,12); write(Club[Participant.MyTeam_ID].Manager); gotoxy(120,12); write('|');
   if qualify AND (locate<>'End') then
    begin 
   gotoxy(45,13); write('============================================================================');
   gotoxy(45,14); write('| 2. Data                      1. Advance                         3. Stats |');
   gotoxy(45,15); write('============================================================================');         
   if (locate='Group Stage') then
    begin
     gotoxy(45,16); write('|'); gotoxy(74,16); write('Next Match :'); gotoxy(120,16); write('|');
     gotoxy(45,17); write('|'); gotoxy(77,17); write('(',UpCase(Participant.MyTeam_Match[my].Status),')'); gotoxy(120,17); write('|');
     gotoxy(45,18); write('|'); gotoxy(69,18); write(Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Phase,' Matchday ',Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Matchday); gotoxy(120,18); write('|');
     gotoxy(45,19); write('|'); gotoxy(66,19); write(Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Home_Team].Team_Name,' vs ',Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Away_Team].Team_Name); gotoxy(120,19); write('|');
     gotoxy(45,20); write('|'); gotoxy(72,20); write(Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Home_Team].Home_Stadium); gotoxy(120,20); write('|');
     gotoxy(45,21); write('|'); gotoxy(71,21); write(Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Home_Team].City,', ',Club[Match[Participant.MyTeam_Group,Participant.MyTeam_Match[my].Match_ID].Home_Team].Country); gotoxy(120,21); write('|');
     gotoxy(45,22); write('|'); gotoxy(120,22); write('|');   
    end
   else if (locate[length(locate)]='g') then
    begin
     gotoxy(45,16); write('|'); gotoxy(120,16); write('|');
     gotoxy(45,17); write('|'); gotoxy(77,17); write('Next :'); gotoxy(120,17); write('|');
     gotoxy(45,18); write('|'); gotoxy(74,18); write(locate); gotoxy(120,18); write('|');
     gotoxy(45,19); write('|'); gotoxy(74,19); write('UEFA Headquarters'); gotoxy(120,19); write('|');
     gotoxy(45,20); write('|'); gotoxy(74,20); write('Nyon, Switzerland'); gotoxy(120,20); write('|');
     gotoxy(45,21); write('|'); gotoxy(120,21); write('|');
     gotoxy(45,22); write('|'); gotoxy(120,22); write('|'); 
    end       
   else if (locate='Round of 16') OR (locate='Quarter Final') OR (locate='Semifinal') then
    begin
     gotoxy(45,16); write('|'); gotoxy(74,16); write('Next Match :'); gotoxy(120,16); write('|');
     gotoxy(45,17); write('|'); gotoxy(77,17); write('(',UpCase(Participant.MyTeam_Match[my].Status),')'); gotoxy(120,17); write('|');
     gotoxy(45,18); write('|'); gotoxy(69,18); write(KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Phase,' Leg ',KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Matchday); gotoxy(120,18); write('|');
     gotoxy(45,19); write('|'); gotoxy(64,19); write(Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Home_Team].Team_Name,' vs ',Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Away_Team].Team_Name); gotoxy(120,19); write('|');
     gotoxy(45,20); write('|'); gotoxy(70,20); write('Aggregate : ',KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Home_Agg,' - ',KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Away_Agg); gotoxy(120,20); write('|'); 
     gotoxy(45,21); write('|'); gotoxy(72,21); write(Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Home_Team].Home_Stadium); gotoxy(120,21); write('|');
     gotoxy(45,22); write('|'); gotoxy(71,22); write(Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Home_Team].City,', ',Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Home_Team].Country); gotoxy(120,22); write('|');         
    end
   else if (locate='Final') then
    begin
     gotoxy(45,16); write('|'); gotoxy(120,16); write('|');
     gotoxy(45,17); write('|'); gotoxy(74,17); write('Next Match :'); gotoxy(120,17); write('|');
     gotoxy(45,18); write('|'); gotoxy(69,18); write(KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Phase); gotoxy(120,18); write('|');
     gotoxy(45,19); write('|'); gotoxy(64,19); write(Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Home_Team].Team_Name,' vs ',Club[KnockOutMatch[Participant.MyTeam_Match[my].Match_ID].Away_Team].Team_Name); gotoxy(120,19); write('|');
     gotoxy(45,20); write('|'); gotoxy(72,20); write(Club[Final_Host].Home_Stadium); gotoxy(120,20); write('|'); 
     gotoxy(45,21); write('|'); gotoxy(71,21); write(Club[Final_Host].City,', ',Club[Final_Host].Country); gotoxy(120,21); write('|');
     gotoxy(45,22); write('|'); gotoxy(120,22); write('|');              
    end;
   gotoxy(45,23); write('============================================================================');
   gotoxy(45,24); write('| 4. Restart Game                                             5. Exit Game |');
   gotoxy(45,25); write('============================================================================');
    gotoxy(71,27); write('* Select Menu : '); readln(menu);
    if (menu<1) OR (menu>5) then
     begin
      gotoxy(64,29); write('* Message :');
      gotoxy(64,30); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;     
    end
  else if (locate='End') then
   begin
   gotoxy(45,13); write('============================================================================');
   gotoxy(45,14); write('| 2. Data                   1. Restart Game                       3. Stats |');
   gotoxy(45,15); write('============================================================================'); 
    if (Club[Champions].Team_ID=Participant.MyTeam_ID) then
     begin
      gotoxy(69,17); write('CONGRATULATIONS ',UpCase(Club[Participant.MyTeam_ID].Manager),'!');
     end;
     gotoxy(45,16); write('|'); gotoxy(120,16); write('|');
     gotoxy(45,17); write('|'); gotoxy(120,17); write('|');
     gotoxy(45,18); write('|'); gotoxy(72,18); write('UEFA CHAMPIONS LEAGUE WINNER'); gotoxy(120,18); write('|');
     gotoxy(45,19); write('|'); gotoxy(75,19); write(UpCase(Club[Champions].Team_Name)); gotoxy(120,19); write('|');
     gotoxy(45,20); write('|'); gotoxy(77,20); write('(',Club[Champions].Country,')'); gotoxy(120,20); write('|'); 
     gotoxy(45,21); write('|'); gotoxy(120,21); write('|');
     gotoxy(45,22); write('|'); gotoxy(120,22); write('|');     
    
      
   gotoxy(45,23); write('============================================================================');
   gotoxy(45,24); write('|                            4. Exit Game                                  |');
   gotoxy(45,25); write('============================================================================');
    gotoxy(71,27); write('* Select Menu : '); readln(menu);
    if (menu<1) OR (menu>4) then
     begin
      gotoxy(64,29); write('* Message :');
      gotoxy(64,30); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;   
   end    
   else if (not(qualify)) then
    begin   
   gotoxy(45,13); write('============================================================================');
   gotoxy(45,14); write('| 2. Data           1. Keep Simulating the Tournament             3. Stats |');
   gotoxy(45,15); write('============================================================================');
     gotoxy(45,16); write('|'); gotoxy(120,16); write('|');
     gotoxy(45,17); write('|'); gotoxy(120,17); write('|');
     gotoxy(45,18); write('|'); gotoxy(70,18); write('Sorry ',Club[Participant.MyTeam_ID].Manager); gotoxy(120,18); write('|');
     gotoxy(45,19); write('|'); gotoxy(65,19); write(UpCase(Club[Participant.MyTeam_ID].Team_Name),' HAS BEEN ELIMINATED'); gotoxy(120,19); write('|');
     gotoxy(45,20); write('|'); gotoxy(120,20); write('|'); 
     gotoxy(45,21); write('|'); gotoxy(120,21); write('|');
     gotoxy(45,22); write('|'); gotoxy(120,22); write('|');   
   gotoxy(45,23); write('============================================================================');
   gotoxy(45,24); write('| 4. Restart Game                                             5. Exit Game |');
   gotoxy(45,25); write('============================================================================');
    gotoxy(71,27); write('* Select Menu : '); readln(menu);
    if (menu<1) OR (menu>5) then
     begin
      gotoxy(64,29); write('* Message :');
      gotoxy(64,30); write('- Wrong menu input, please input menu correctly!');
      readln;
      GoTo showagain;
     end;
    end;
   MenuManageTeam:=choice;
  end;

 procedure Main_Screen;
  begin
   gotoxy(83,15); write('E'); gotoxy(86,15); write('F');
   gotoxy(81,16); write('U'); gotoxy(88,16); write('A');
   gotoxy(70,18); write('C H A M P I O N S   L E A G U E');
   gotoxy(82,20); write('FANTASY');
   gotoxy(85,23); write('by');
   gotoxy(77,24); write('Stevan Del Arisandi');
   gotoxy(81,25); write('1301184365');
   gotoxy(82,26); write('IF-42-02');   
   gotoxy(2,40); write('* Please Maximize/Switch to Full Screen for better Experience (Recommended)');
   gotoxy(74,30); write('Press any Key to Start...');
   repeat
   until KeyPressed;
  end;

 begin
  crt.WindMaxY := 200;
  crt.WindMaxX := 200; 
  textcolor(15); 
  RestartGame:
  Set_Defaults;
  clrscr;
  Main_Screen;
  ChangeTeam:
  AssignTeamData;
  Participant.MyTeam_ID:=SelectTeam(Participant.MyTeam_ID);
  case InputPlayerName(Club[Participant.MyTeam_ID].Manager) of
  1 : GoTo Drawing;
  3 : GoTo ChangeTeam;
  end;

  Drawing:
  
  case (GroupDrawing(Menu)) of
  1 : GoTo StartGame;
  2 : GoTo Drawing;
  3 : GoTo ChangeTeam;
  end;

  StartGame:
  Set_Final_Host;
  GroupMatchData;

  Locator:='Group Stage';
  Matchday:=1;
  Participant.MyTeam_Qualify:=TRUE;
  for Match_Code:=1 to 6 do
   begin

    Menu_GroupStage:
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Play_GroupStage;
    2 : begin
         Menu_Data;
         GoTo Menu_GroupStage;
        end;
    3 : begin
         Menu_Stats(Locator);
         GoTo Menu_GroupStage;
        end;
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end;

    Play_GroupStage:   
    ViewMatchResults('Simulate',Matchday);
    CalculateMatchResults(Matchday);
    View_Group_Standings;
    Matchday:=Matchday+2;
   end;

  Locator:='Round of 16';   
  KnockOut_Drawing(Locator);
  Participant.MyTeam_Qualify:=Check_Qualified(Locator,Participant.MyTeam_ID);

  Locator:='Round of 16 Drawing';
  temp:=Participant.MyTeam_Match[7].Match_ID;
  Menu_Draw_Round16:
  Participant.MyTeam_Match[7].Match_ID:=temp;
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Draw_Round16;
    2 : begin    
         Menu_Data;
         GoTo Menu_Draw_Round16;
        end;
    3 : begin
         Participant.MyTeam_Match[7].Match_ID:=0;
         Menu_Stats(Locator);
         GoTo Menu_Draw_Round16;
        end; 
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end; 

  Draw_Round16:
  Match_Code:=7;
  Locator:='Round of 16';
  View_KnockOut_Draw(Locator);
  for Matchday:=1 to 2 do
   begin
    Menu_Round16:
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Play_Round16;
    2 : begin
         Menu_Data;
         GoTo Menu_Round16;
        end;
    3 : begin
         Menu_Stats(Locator);
         GoTo Menu_Round16;
        end;    
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end;
    Play_Round16:
    View_KnockOut_Match(Locator,Matchday);
    Simulate_KnockOut_Match(Locator,Matchday);
    View_KnockOut_Match_Results(Locator,'Simulate',Matchday);
    Match_Code:=Match_Code+1;
   end;

  Locator:='Quarter Final';   
  KnockOut_Drawing(Locator);
  Participant.MyTeam_Qualify:=Check_Qualified(Locator,Participant.MyTeam_ID);

  Locator:='Quarter Final Drawing';
  temp:=Participant.MyTeam_Match[9].Match_ID;
    Menu_Draw_QuarterFinal:
    Participant.MyTeam_Match[9].Match_ID:=temp;    
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Draw_QuarterFinal;
    2 : begin   
         Menu_Data;
         GoTo Menu_Draw_QuarterFinal;
        end;
    3 : begin
         Participant.MyTeam_Match[9].Match_ID:=0; 
         Menu_Stats(Locator);
         GoTo Menu_Draw_QuarterFinal;
        end;    
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end;

  Draw_QuarterFinal:
  Match_Code:=9;
  Locator:='Quarter Final';   
  View_KnockOut_Draw(Locator);
  for Matchday:=1 to 2 do
   begin
    Menu_QuarterFinal:
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Play_QuarterFinal;
    2 : begin
         Menu_Data;
         GoTo Menu_QuarterFinal;
        end;
    3 : begin
         Menu_Stats(Locator);
         GoTo Menu_QuarterFinal;
        end;    
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end;
    Play_QuarterFinal:   
    View_KnockOut_Match(Locator,Matchday);
    Simulate_KnockOut_Match(Locator,Matchday);
    View_KnockOut_Match_Results(Locator,'Simulate',Matchday);
    Match_Code:=Match_Code+1;    
   end;

  Locator:='Semifinal';   
  KnockOut_Drawing(Locator);
  Participant.MyTeam_Qualify:=Check_Qualified(Locator,Participant.MyTeam_ID);

  Locator:='Semifinal Drawing';
  temp:=Participant.MyTeam_Match[11].Match_ID;
    Menu_Draw_Semifinal:
  Participant.MyTeam_Match[11].Match_ID:=temp;    
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Draw_Semifinal;
    2 : begin    
         Menu_Data;
         GoTo Menu_Draw_Semifinal;
        end;
    3 : begin
         Participant.MyTeam_Match[11].Match_ID:=0;
         Menu_Stats(Locator);
         GoTo Menu_Draw_Semifinal;
        end;    
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end; 

  Draw_Semifinal:
  Match_Code:=11;
  Locator:='Semifinal';   
  View_KnockOut_Draw(Locator);
  for Matchday:=1 to 2 do
   begin
    Menu_Semifinal:
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Play_Semifinal;
    2 : begin
         Menu_Data;
         GoTo Menu_Semifinal;
        end;
    3 : begin
         Menu_Stats(Locator);
         GoTo Menu_Semifinal;
        end;    
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
        end;
    Play_Semifinal:  
    View_KnockOut_Match(Locator,Matchday);
    Simulate_KnockOut_Match(Locator,Matchday);
    View_KnockOut_Match_Results(Locator,'Simulate',Matchday);
    Match_Code:=Match_Code+1;    
   end;

  Match_Code:=13;
  Locator:='Final';

  KnockOut_Drawing(Locator);
  Participant.MyTeam_Qualify:=Check_Qualified(Locator,Participant.MyTeam_ID); 
  View_KnockOut_Draw(Locator);
    Menu_Final:
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo Play_Final;
    2 : begin
         Menu_Data;
         GoTo Menu_Final;
        end;
    3 : begin
         Menu_Stats(Locator);
         GoTo Menu_Final;
        end;    
    4 : GoTo RestartGame;
    5 : GoTo ExitGame;
    end;
  Play_Final:
  View_KnockOut_Match(Locator,1);
  Simulate_KnockOut_Match(Locator,Matchday);
  View_KnockOut_Match_Results(Locator,'Simulate',1);
  Show_Champions;
  Locator:='End';
  Menu_End:
    case (MenuManageTeam(Menu,Locator,Match_Code,Participant.MyTeam_Qualify)) of
    1 : GoTo RestartGame;
    2 : begin
         Menu_Data;
         GoTo Menu_End;
        end;
    3 : begin
         Menu_Stats(Locator);
         GoTo Menu_End;
        end;    
    4 : GoTo ExitGame;
    end;  

  readln;
  ExitGame:
 end.           