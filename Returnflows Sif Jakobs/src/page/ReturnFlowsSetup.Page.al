page 77150 "Return Flows Setup"
{

    PageType = Card;
    SourceTable = "Return Flows Setup";
    Caption = 'Return Flows Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Order Exchange Tag"; Rec."Order Exchange Tag")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}
