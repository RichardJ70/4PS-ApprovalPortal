pageextension 86700 "RISA DV Posted Purch. Invoice" extends "Approval (Compressed)"
{
    layout
    {
        addlast(FactBoxes)
        {
            part("Document Viewer Documents 4PS"; "Document Viewer Documents 4PS")
            {
                ApplicationArea = All;
                Caption = 'Document Viewer Documents';
            }
        }
        addlast(FactBoxes)
        {
            part("Document Viewer 4PS"; "Document Viewer 4PS")
            {
                ApplicationArea = All;
                Caption = 'Document Viewer';
                Provider = "Document Viewer Documents 4PS";
                SubPageLink = "No." = field("No."), Description = field(Description), "Source Type" = field("Source Type");
            }
        }

        addafter(Control1100485000)
        {
            part(InvoiceLines; "Posted Purch. Invoice Subform")
            {
                ApplicationArea = all;
                Editable = false;
                ShowFilter = false;
                Visible = ShowInvoiceLines;
                SubPageLink = "Document No." = field("Document No."), "Line No." = field("Consent Rule Line No.");
            }

            part(CrMemoLines; "Posted Purch. Cr. Memo Subform")
            {
                ApplicationArea = all;
                Editable = false;
                ShowFilter = false;
                Visible = ShowCrMemoLines;
                SubPageLink = "Document No." = field("Document No."), "Line No." = field("Consent Rule Line No.");
            }
        }
        modify("Document Type")
        {
            Style = Unfavorable;
            StyleExpr = CreditMemoColor;
        }
        modify(Comments)
        {
            Visible = false;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        FillDocumentViewerFactbox();
    end;

    local procedure FillDocumentViewerFactbox()
    var
        DocumentViewerTempDoc: Record "Doc. Viewer Temp. Doc. 4PS";
        DocumentProperties: Record "Document Properties";
        PurchSetup: Record "Purchases & Payables Setup";
        DocumentLinkManagement: Codeunit "Document Link Management";
        EmptyRecID: RecordID;
        PostedPurchInv: Record "Purch. Inv. Header";
        PostedCrMemo: Record "Purch. Cr. Memo Hdr.";

    begin
        // Publisher call here
        PurchSetup.Get();
        CurrPage."Document Viewer Documents 4PS".Page.ResetPage();
        if Rec."Document Type" = Rec."Document Type"::Invoice then 
            if PostedPurchInv.Get(Rec."Document No.") then
                DocumentLinkManagement.GetDocuments(DocumentProperties, PostedPurchInv.RecordId.GetRecord());
        if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then 
            if PostedCrMemo.Get(Rec."Document No.") then
                DocumentLinkManagement.GetDocuments(DocumentProperties, PostedPurchInv.RecordId.GetRecord());

        DocumentProperties.MarkedOnly(true);
        CurrPage."Document Viewer Documents 4PS".Page.SetExternal4PSDocuments(DocumentProperties);
        CurrPage."Document Viewer Documents 4PS".Page.Update(false);
        CurrPage."Document Viewer 4PS".Page.SetEmailSubject(Rec."Document No.");
    end;

    trigger OnAfterGetRecord()
    begin
        ShowInvoiceLines := Rec."Document Type" = Rec."Document Type"::Invoice;
        ShowCrMemoLines := not ShowInvoiceLines;
        CreditMemoColor := Rec."Document Type" = Rec."Document Type"::"Credit Memo";
    end;

    var
        ShowCrMemoLines: Boolean;
        ShowInvoiceLines: Boolean;
        CreditMemoColor: Boolean;
        PurInvoice: Record "Purch. Inv. Header";
        PurCrMemo: Record "Purch. Cr. Memo Hdr.";
}