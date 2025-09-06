package in.pandac.ecommerce.payment;

import in.pandac.ecommerce.customer.CustomerResponse;
import in.pandac.ecommerce.order.PaymentMethod;

import java.math.BigDecimal;

public record PaymentRequest(
        BigDecimal amount,
        PaymentMethod paymentMethod,
        Integer orderId,
        String orderReference,
        CustomerResponse customer
) {
}
