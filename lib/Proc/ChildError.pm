package Proc::ChildError;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(explain_child_error);

sub explain_child_error {
    my $opts;
    if (ref($_[0]) eq 'HASH') {
        $opts = shift;
    } else {
        $opts = {};
    }

    my ($num, $str);
    if (defined $_[0]) {
        $num = $_[0];
        $str = $_[1];
    } else {
        $num = $?;
        $str = $!;
    }

    my $prefix = "";
    if (defined $opts->{prog}) {
        $prefix = "$opts->{prog} ";
    }

    if ($num == -1) {
        return "${prefix}failed to execute: ".($str ? "$str ":"")."($num)";
    } elsif ($num & 127) {
        return sprintf(
            "${prefix}died with signal %d, %s coredump",
            ($num & 127),
            (($num & 128) ? 'with' : 'without'));
    } else {
        return sprintf("${prefix}exited with code %d", $num >> 8);
    }
}

1;
# ABSTRACT: Explain process child error

=head1 FUNCTIONS

=head2 explain_child_error([\%opts, ]$child_error, $os_error) => STR

Produce a string description of an error number. C<$child_error> defaults to
C<$?> if not specified. C<$os_error> defaults to C<$!> if not specified.

The algorithm is taken from perldoc -f system. Some sample output:

 failed to execute: No such file or directory (-1)
 died with signal 15, with coredump
 exited with value 3

An options hashref can be specified as the first argument to add information.
Currently known keys:

=over

=item * prog => str

Program name/path, to include in error messages:

 /usr/bin/foo failed to execute: Permission denied (-1)
 foo died with signal 15, with coredump
 /usr/bin/foo exited with value 3

=back

=cut
