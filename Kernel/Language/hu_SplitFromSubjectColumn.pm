# --
# Kernel/Language/hu_SplitFromSubjectColumn.pm - Hungarian translations for SplitFromSubjectColumn
# Copyright (C) 2016 Perl-Services.de, http://perl-services.de
# Copyright (C) 2016 Balázs Úr, http://www.otrs-megoldasok.hu
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_SplitFromSubjectColumn;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Kernel/Config/Files/SplitFromSubjectColumn.xml
    $Lang->{'Module to split the from/subject column in ticket overviews.'} =
        'Egy modul a feladó/tárgy oszlop felosztásához a jegyáttekintőkben.';

    return 1;
}

1;
