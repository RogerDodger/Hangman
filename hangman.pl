#usr/bin/perl

use strict;
use warnings;
use Win32::Console::ANSI;
use List::Util 'shuffle';
do 'dictionary.pl';

my %c = (
	s => "\e[s",
	r => "\e[u",
	a => "\e[u\e[0J",
	u => "\e[A",
	d => "\e[B",
	dsc => "\e[E",
	asc => "\e[F",
	ascx => "\e[13F",
	cld => "\e[0J",
	clu => "\e[1J",
	cll => "\e[K",
);
my %tally = (win => 0, lose => 0);
my %in;
my $gamenum = 0;

while (1) {
	my @dictionary;
	my $dic_pic = input("\nChoose a dictionary
 1. Level 1 British English
 2. Level 2 British English
 3. Level 3 British English
 4. Level 4 British English
 5. Level 5 British English
 6. Level 6 British English
 7. Level 7 British English
 8. Level 8 British English
[9] Basic English
 10. Custom\n>", 9, (1..10));
	{
		no warnings 'once';
		my ($a, $i);
		for (1..10) {
			$a++;
			$i++;
			if ($a <= 8) {$i = 8};
			push @dictionary, @{$Dictionary::hash{$_}} if $dic_pic >= $a and $dic_pic <= $i;
		}
	}
	my ($a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, @a) = (" ") x 11;
	$a[$_] = " " for (0..11);
	%in = ();
	$gamenum++;
	$a[$_] = " " for (0..11);
	my $game_word = (@dictionary = shuffle(@dictionary))[0];
	my @letters = split "", uc $game_word;
	my @board = map {(my $dm = $_) =~ tr/_A-Za-z/ _/; $dm} @letters;
	my ($count, $winner) = 0 x 2;
	print "_____________________________\nGame #$gamenum | Tally $tally{win}-$tally{lose}\n";
	until ($winner) {
		print "
 $c$c$c$c$c$c$c$c$c
$b$d    $e        ______
$b     $f       |$a[0]$a[1]$a[2]$a[3]$a[4]$a[5]|
$b   $i$i$g$k$k     |$a[6]$a[7]$a[8]$a[9]$a[10]$a[11]|
$b     $g       --------
$b    $h $j
$b$a$a$a$a$a$a$a$a$a\n\n";
		print " ", join " ", @board , "\n\n";
		$winner = 2, next if $k eq "-";
		$winner = 1, next if !grep $_ eq "_", @board;
		my $input = get_letter();
		if (!grep $_ eq $input, @letters) {
			do{$_ = $input, last if $_ eq " "} for @a;
			my $ii = 0;
			for($a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k) {
				if($ii++ == $count) {
					$_ = (qw(_ | _ / | O | / - \ -))[$count];
					last;
				}
			}
			$count++;
		}
		my $z = 0;
		for (@letters) {
			$board[$z] = $input if $_ eq $input;
			$z++;
		}
		if (length($game_word) < 40) {print "$c{ascx}$c{cld}"} else {print "$c{ascx}$c{asc}$c{cld}"};
	}
	if ($winner == 1) { 
	print "\n\nCongratulations, you won! Press enter to play again.";
	$tally{win}++; };
	if ($winner == 2) { print "\n\nBad luck, you have been hanged. The word was $game_word. Press enter to play again.";
	$tally{lose}++; };
	<STDIN>;
}

sub input {
	my ($message, $default, @accepted) = @_;
	print $message;
	while(1) {
		(my $in = <STDIN>) =~ s/^\s+|\s+$//g;
		return $in if grep $in eq $_, @accepted or @accepted == 0;
		return $default if $in eq "" and defined $default;
		print "Please input one of the following: ", join(", ", @accepted), ". ";
	}
}

sub get_letter {
	print "Choose a letter:\n";
	{
		print "$c{cll}>";
		chomp(my $_ = <STDIN> || '');
		$_ = uc $_;
		print "$c{cll}Invalid input: length != 1.$c{asc}" and redo if length() != 1;
		print "$c{cll}Invalid input: not an English letter.$c{asc}" and redo if !/[A-Za-z]/;
		print "$c{cll}Invalid input: You've already tried that letter.$c{asc}" and redo if $in{$_};
		print "$c{cld}";
		$in{$_} = 1;
		return $_;
	}
}