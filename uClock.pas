unit uClock;

interface

  type
    Clock = class
    private
      FHoursHand : integer;
      FMinutesHand : integer;
    public
      constructor SetHands(const AHours : integer = 0; const AMinutes : integer = 0);
      function ToString : string;
      function Add(const AMinutes : integer = 0) : Clock;
      function Subtract(AMinutes : integer = 0) : Clock;
      function Equal(const AClock : Clock) : boolean;
    end;

implementation

  uses
    SysUtils;

  constructor Clock.SetHands(const AHours : integer = 0; const AMinutes : integer = 0);
    var
      ExcedingHours : integer;
    begin
      self.FMinutesHand := 0;
      self.FHoursHand := 0;
      ExcedingHours := 0;
      if 0 <> AMinutes then
        begin
          self.FMinutesHand := (self.FMinutesHand + 60 + (AMinutes mod 60)) mod 60;
          if 0 <= AMinutes then
            ExcedingHours := AMinutes Div 60
          else
            ExcedingHours := (AMinutes + 1) Div 60 - 1;
        end;
      if 0 <> ExcedingHours then
        self.FHoursHand := (self.FHoursHand + 24 + ExcedingHours) mod 24;
      if 0 <> AHours then
        self.FHoursHand := (self.FHoursHand + 24 + (AHours mod 24)) mod 24;
    end;

  function Clock.ToString : string;
    var
      HoursText, MinutesText : string;
    begin
      if 10 > self.FHoursHand then
        HoursText := '0';
      if 10 > self.FMinutesHand then
        MinutesText := '0';
      Result := HoursText + IntToStr(self.FHoursHand) + ':' + MinutesText + IntToStr(self.FMinutesHand);
    end;

  function Clock.Add(const AMinutes : integer = 0) : Clock;
    var
      ExcedingHours : integer;
    begin
      ExcedingHours := 0;
      if 0 <> AMinutes then
        begin
          self.FMinutesHand := self.FMinutesHand + AMinutes;
          ExcedingHours := self.FMinutesHand Div 60;
          self.FMinutesHand := self.FMinutesHand mod 60;
        end;
      if 0 <> ExcedingHours then
        self.FHoursHand := (self.FHoursHand + ExcedingHours) mod 24;
      Result := self;
    end;

  function Clock.Subtract(AMinutes : integer = 0) : Clock;
    var
      ExcedingHours : integer;
    begin
      ExcedingHours := 0;
      AMinutes := Aminutes * (-1);
      if 0 <> AMinutes then
        begin
          if Abs(AMinutes) > self.FMinutesHand then
            ExcedingHours := (AMinutes + 1) Div 60 - 1;
          self.FMinutesHand := (self.FMinutesHand + 60 + (AMinutes mod 60)) mod 60;
        end;
      if 0 <> ExcedingHours then
        self.FHoursHand := (self.FHoursHand + 24 + ExcedingHours) mod 24;
      Result := self;
    end;

  function Clock.Equal(const AClock : Clock) : boolean;
    begin
      Result := (AClock.FHoursHand = self.FHoursHand) AND (AClock.FMinutesHand = self.FMinutesHand);
    end;

end.
