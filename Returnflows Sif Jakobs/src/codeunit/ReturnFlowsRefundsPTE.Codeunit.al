codeunit 77151 "ReturnFlows Refunds PTE"
{
    procedure CheckReturnFlowsRefund(RefundHeader: Record "Shpfy Refund Header"; var SalesHeader: Record "Sales Header")
    var
        ShpfyOrderHeader: Record "Shpfy Order Header";
        SalesLine: Record "Sales Line";
        Shop: Record "Shpfy Shop";
    begin
        ShpfyOrderHeader.Get(RefundHeader."Order Id");
        if not IsReturnFlowsExhchangeRefund(ShpfyOrderHeader) then
            exit;
        Shop.Get(ShpfyOrderHeader."Shop Code");

        DeleteRefundLine(SalesHeader, Shop);
    end;

    local procedure IsReturnFlowsExhchangeRefund(ShpfyOrderHeader: Record "Shpfy Order Header"): Boolean
    var
        ReturnFlowsSetup: Record "Return Flows Setup";
        ShpfyTag: Record "Shpfy Tag";
    begin
        ReturnFlowsSetup.GetRecordOnce();
        ShpfyTag.SetRange("Parent Id", ShpfyOrderHeader."Shopify Order Id");
        ShpfyTag.SetRange("Parent Table No.", Database::"Shpfy Order Header");
        ShpfyTag.SetRange(Tag, ReturnFlowsSetup."Order Exchange Tag");
        exit(not ShpfyTag.IsEmpty());
    end;

    local procedure DeleteRefundLine(var SalesHeader: Record "Sales Header"; Shop: Record "Shpfy Shop")
    var
        SalesLine: Record "Sales Line";
        ReleaseSalesDocument: Codeunit "Release Sales Document";

    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.type::"G/L Account");
        SalesLine.SetRange("No.", Shop."Refund Account");
        SalesLine.SetFilter("Line Amount", '<0');
        if SalesLine.FindLast() then begin
            ReleaseSalesDocument.Reopen(SalesHeader);
            SalesLine.Delete(true);
            ReleaseSalesDocument.Run(SalesHeader);
        end;
    end;
}