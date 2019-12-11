
my $start = 124075;
my $end   = 580769;

# six digit number
# inside range
# duplicate adjacent digit
# digits never decrease from left to right

# a) find number of possibilities

my @start_digits  = $start.comb;
my @end_digits    = $end.comb;

#say "elems " ~ @start_digits.elems;
#say "lastindex " ~ @start_digits[@start_digits.elems - 1];
my $permutations = 0;
for @start_digits.reverse.kv -> $index, $current_digit {
  if $index + 1 == @start_digits.elems  {
    last;
  }
  say "current index " ~ @start_digits[@start_digits.elems - 2 - $index];
  $permutations += 9 - @start_digits[@start_digits.elems - 2 - $index];
}

say $permutations;
