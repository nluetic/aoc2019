
my $fh = open "calendar/day03.txt", :r;
my $input = $fh.slurp;
$fh.close;

my @wires = $input.chomp.split(/\n/, :skip_empty);

my %fields;

for @wires.kv -> $index, $wire {
  my @moves = $wire.split(/\,/, :skip_empty);
  %fields{$index} = [];
  %fields{$index}.push([0,0]);
  for @moves -> $move {
    my $current = %fields{$index}.tail;
    my ($direction, @step_parts) = $move.comb(1);
    my $steps = @step_parts.join;

    if $direction ne "R" ^ "U" ^ "L" ^ "D" {
      die("Don't know direction $direction");
    }

    my $coordinate = 1;
    if $direction eq "L" || $direction eq "D" {
      $coordinate = -1;
    }
    if $direction eq "R" ^ "L" {
      for 1..$steps -> $step {
        #say "current $current coordinate $coordinate direction $direction step $step";
        %fields{$index}.push( [$current[0], $current[1] + $coordinate * $step] );
      }
    }
    else {
      for 1..$steps -> $step {
        #say "current $current coordinate $coordinate direction $direction step $step";
        %fields{$index}.push( [$current[0] + $coordinate * $step, $current[1]] );
      }
    }
  }
}

my %fields_sorted;
for @wires.kv -> $index, $wire {
  %fields_sorted{$index} = sort {  $^a[0] <=> $^b[0] or $^a[1] <=> $^b[1] }, %fields{$index};
  #say %fields{$index};
}

my $scanner_iterator = %fields_sorted{0}.iterator;
my $matcher_iterator = %fields_sorted{1}.iterator;

my @matches;
my $scanner = $scanner_iterator.pull-one;
my $matcher = $matcher_iterator.pull-one;
repeat {
  if ($scanner[0] < $matcher[0] ||
     ($scanner[0] == $matcher[0] && $scanner[1] < $matcher[1])) {
    $scanner = $scanner_iterator.pull-one;
    next;    
  }
  if $scanner[0] == $matcher[0] && $scanner[1] == $matcher[1] {
    if $scanner[0] != 0 && $scanner[1] != 0 {
      @matches.push($scanner);
    }
  }
  $matcher = $matcher_iterator.pull-one;
} until $scanner.Str eq IterationEnd.Str || $matcher.Str eq IterationEnd.Str;

say @matches.join("\n");

# part 1: find closest intersection
say [+] @matches
          .sort( {  abs($^a[0]) + abs($^a[1]) <=> abs($^b[0]) + abs($^b[1]) } )
          .head
          .map( { abs($_) } );

# part 2: find intersection with minimal combined length
my %distances;
for @matches -> $match {
  %distances{$match} = 0;
  my @distance;
  for %fields.keys -> $wire {
    @distance[$wire] = 0;
    for %fields{$wire}.Array -> $move {
      #say "move $move";
      #say "match $match";
      if $match[0] == $move[0] && $match[1] == $move[1] {
        #say "found match for wire $wire";
        last;
      }
      @distance[$wire]++;
    }
  }
  my $distance = [+] @distance;
  if $distance > %distances{$match} {
    %distances{$match} = $distance;  
  }
}

say min(%distances.values);

# iterate over matches
# find index in paths; sum lengths
# get min lengths path
