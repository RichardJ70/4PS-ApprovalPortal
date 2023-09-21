pageextension 86701 "RISA Approval Portal" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Chart of Accounts")
        {

            action("Approval Portal")
            {
                Caption = 'Approval Portal';
                RunObject = report "RISA Approval Portal Link";
                ToolTip = 'Open the approval portal with code GKP from the websource table';
            }

        }
    }
}
