report 86700 "RISA Approval Portal Link"
{
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPreReport()
    var
        WebSource: Record "Web Source";

    begin
        if WebSource.Get('GKP') then
            Hyperlink(WebSource.URL);
    end;

}