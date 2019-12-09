
my $fh = open "calendar/day01.txt", :r;
my $input = $fh.slurp;
$fh.close;

my @modules = $input.chomp.split(/\n/, :skip_empty);

sub get_fuel(Int $mass, Bool $recurse) {
  my $fuel = ($mass / 3).Int - 2;
  if ($recurse == False) {
    return $fuel;
  }
  return $fuel <= 0 ?? 0 !! $fuel + get_fuel($fuel, $recurse);
}
# Task 1
say [+] @modules.map( { get_fuel($_.Int, False) } );
# Task 2
say [+] @modules.map( { get_fuel($_.Int, True) } );
