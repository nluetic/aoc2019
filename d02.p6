
my $fh = open "calendar/day02.txt", :r;
my $input = $fh.slurp;
$fh.close;

my @lines;

my @input_values = $input.split(/\,/, :skip_empty);

# part one
#@values[1] = 12;
#@values[2] = 2;

LABEL: for 0..99 -> $noun {
  for 0..99 -> $verb {
    my @values = @input_values;

    #say $noun;
    #say $verb;
    @values[1] = $noun;
    @values[2] = $verb;

    my $line_iterator = @values.iterator;
    my $value = $line_iterator.pull-one;

    repeat {
      given $value {
        when  1 {
          my $result = @values[$line_iterator.pull-one] + @values[$line_iterator.pull-one];
          @values[$line_iterator.pull-one] = $result;
        }
        when  2 {
          my $result = @values[$line_iterator.pull-one] * @values[$line_iterator.pull-one];
          @values[$line_iterator.pull-one] = $result;
        }
        when  99 { 
          # reached end of program
          last;
        }
        default: { 
          say("invalid opcode $value found for $noun/$verb"); 
          last;
        }
      }
      $value = $line_iterator.pull-one;
    } until $value.Str eq IterationEnd.Str;

    #say @values[0];
    if @values[0] == 19690720 {
      say "Solution is $noun$verb";
      last LABEL;
    }
  }
}
