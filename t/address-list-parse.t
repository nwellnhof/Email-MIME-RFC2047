use utf8;

use Test::More tests => 1 + 3;

BEGIN {
    use_ok('Email::MIME::RFC2047::AddressList');
};

my @tests = (
    '"Group 1 (Test)": =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, =?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>;, wellnhofer@aevum.de',
    [
        {
            name => 'Group 1 (Test)',
            mailbox_list => [
                { name => 'Keld Jørn Simonsen', address => 'keld@dkuug.dk' },
                { name => 'André Pirard', address => 'PIRARD@vm1.ulg.ac.be' },
            ],
        },
        {
            address => 'wellnhofer@aevum.de',
        },
    ],
    'Mary Smith <mary@x.test>, jdoe@example.org, Who? <one@y.test>',
    [
        { name => 'Mary Smith', address => 'mary@x.test' },
        { address => 'jdoe@example.org' },
        { name => 'Who?', address => 'one@y.test' },
    ],
    '<boss@nil.test>, "Giant; \"Big\" Box" <sysservices@example.net>',
    [
        { address => 'boss@nil.test' },
        { name => 'Giant; "Big" Box', address => 'sysservices@example.net' },
    ],
);

for(my $i=0; $i<@tests; $i+=2) {
    my ($string, $expect) = ($tests[$i], $tests[$i+1]);

    my $mailbox = Email::MIME::RFC2047::AddressList->parse($string);
    is_deeply($mailbox, $expect, "parse $string");
}

