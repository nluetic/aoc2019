
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

for @wires.kv -> $index, $wire {
  %fields{$index} = sort {  $^a[0] <=> $^b[0] or $^a[1] <=> $^b[1] }, %fields{$index};
  #say %fields{$index};
}

my @matches;

my $scanner_iterator = %fields{0}.iterator;
my $matcher_iterator = %fields{1}.iterator;

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

say [+] @matches.sort( {  abs($^a[0]) + abs($^a[1]) <=> abs($^b[0]) + abs($^b[1]) } ).head.map( { abs($_) } );
