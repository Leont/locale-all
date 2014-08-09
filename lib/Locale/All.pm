package Locale::All;
use strict;
use warnings;

use POSIX qw/setlocale/;

sub TIESCALAR {
	my ($class, $constant) = @_;
	return bless \$constant, $class;
}

sub FETCH {
	my $self = shift;
	return setlocale($$self);
}

sub STORE {
	my ($self, $value) = @_;
	setlocale($$self, $value);
	return;
}

package Locale::Info;

use I18N::Langinfo qw/langinfo/;
use Carp;

sub TIESCALAR {
	my ($class, $constant) = @_;
	return bless \$constant, $class;
}

sub FETCH {
	my $self = shift;
	return langinfo($$self);
}

sub STORE {
	my ($self, $value) = @_;
	croak "Can't set langinfo";
}

{
	package Locale;

	tie our $All,       'Locale::All', POSIX::LC_ALL;
	tie our $Collate,   'Locale::All', POSIX::LC_COLLATE;
	tie our $CType,     'Locale::All', POSIX::LC_CTYPE;
	tie our $Messages,  'Locale::All', POSIX::LC_MESSAGES;
	tie our $Monetary,  'Locale::All', POSIX::LC_MONETARY;
	tie our $Numeric,   'Locale::All', POSIX::LC_NUMERIC;
	tie our $Time,      'Locale::All', POSIX::LC_TIME;

	tie our $Codeset,   'Locale::Info', I18N::Langinfo::CODESET;
	tie our $Yesexpr,   'Locale::Info', I18N::Langinfo::YESEXPR;
	tie our $Noexpr,    'Locale::Info', I18N::Langinfo::NOEXPR;

	tie our $Radixchar, 'Locale::Info', I18N::Langinfo::RADIXCHAR;
	tie our $Thousep,   'Locale::Info', I18N::Langinfo::THOUSEP;
	tie our $Crncystr,  'Locale::Info', I18N::Langinfo::CRNCYSTR;

	our (@Day, @AbDay);
	no strict 'refs';
	for my $i (1 .. 7) {
		tie $Day[$i],   'Locale::Info', &{"I18N::Langinfo::DAY_$i"};
		tie $AbDay[$i], 'Locale::Info', &{"I18N::Langinfo::ABDAY_$i"};
	}
	our (@Mon, @AbMon);
	for my $i (1 .. 12) {
		tie $Mon[$i],   'Locale::Info', &{"I18N::Langinfo::MON_$i"};
		tie $AbMon[$i], 'Locale::Info', &{"I18N::Langinfo::ABMON_$i"};
	}
}

{
	package Locale::Format;

	tie our $Datetime, 'Locale::Info', I18N::Langinfo::D_T_FMT;
	tie our $Date,     'Locale::Info', I18N::Langinfo::D_FMT;
	tie our $Time,     'Locale::Info', I18N::Langinfo::T_FMT;
}

#ABSTRACT: Simple access to locale information

1;
