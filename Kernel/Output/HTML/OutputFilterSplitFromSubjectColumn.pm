# --
# Kernel/Output/HTML/OutputFilterSplitFromSubjectColumn.pm
# Copyright (C) 2014 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterSplitFromSubjectColumn;

use strict;
use warnings;

use List::Util qw(first);

our $VERSION = '0.02';

our @ObjectDependencies = qw(
    Kernel::System::Web::Request
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{UserID} = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get template name
    $Param{Templates} ||= { AgentTicketQueue => 1 };
    my $Action = $ParamObject->GetParam( Param => 'Action' );

    return 1 if !$Action;
    return 1 if !$Param{Templates}->{$Action};

    # extract table (overview) from html
    my ($Table) = ${ $Param{Data} } =~ m{ (<table \s+ class="TableSmall .*? </table>) }xms;

    return 1 if !$Table;

    my $TableNew = $Table;

    $TableNew =~ s!(<thead> \s+ <tr> \s+ ((?:<th .*? </th> \s*)*)) (<th \s+ class="OverviewHeader \s+ Title\b .*? </th>)!"$1" . _SplitHeader($3)!exms;

    my $Position = () = $2 =~ m{(</th>)}g;

    # add cells per row
    $TableNew =~ s!<tr [^>]*? > \s+ (?:<td .*? </td>\s* ){$Position} \K \s* (<td .*? </td>)!_SplitBody( $1 );!exmsg;

    ${ $Param{Data} } =~ s{<table \s+ class="TableSmall .*? </table>}{$TableNew}xms;

    return ${ $Param{Data} };
}

sub _SplitHeader {
    my ( $Col) = @_;

    my ($Value) = $Col =~ m{<a [^>]*? >(.+)</a>}smx;
    my ($From,$Subject) = split /\//, $Value;

    my $SortSub = sub{
        my $Link = $_[0];
        #$Link =~ s{SortBy=\K.*?;}{$_[1];};
        $Link;
    };

    $Col =~ s{(<th [^>]*? > \s* <a [^>]*? >) [^<]+ (</a> \s* </th>)}{$SortSub->($1, 'From') . "$From$2" . $SortSub->($1,'Subject') . "$Subject$2"}esmx;

    $Col;
}

sub _SplitBody {
    my ($Col) = @_;

    $Col =~ s{</div>\K}{</td><td>};
    $Col;
}

1;
