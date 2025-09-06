package in.pandac.ecommerce.kafka;

import in.pandac.ecommerce.customer.CustomerResponse;
import in.pandac.ecommerce.order.PaymentMethod;
import in.pandac.ecommerce.product.PurchaseResponse;

import java.math.BigDecimal;
import java.util.List;

public record OrderConfirmation(
        String orderReference,
        BigDecimal totalAmount,
        PaymentMethod paymentMethod,
        CustomerResponse customer,
        List<PurchaseResponse> products

) {
}
