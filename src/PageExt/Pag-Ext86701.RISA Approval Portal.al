pageextension 86701 "RISA Approval Portal" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Chart of Accounts")
        {

            action("Approval Portal")
            {
                ApplicationArea = All;
                Caption = 'Approval Portal';
                RunObject = report "RISA Approval Portal Link";
            }

        }
    }
}
