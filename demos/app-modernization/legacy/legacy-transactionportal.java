// Legacy Monolithic Transaction Portal
// NOTE: Example code for demonstration purposes only.
// Everything jammed into one file, no clear boundaries, no separation of concerns.

import java.util.*;

public class TransactionPortal {

    // Fake in-memory "database"
    private static Map<String, Double> accounts = new HashMap<>();
    static {
        accounts.put("12345", 1500.0);
        accounts.put("67890", 20.0);
    }

    public static void main(String[] args) {
        System.out.println("=== Legacy Transaction Portal Starting ===");

        // Giant switchboard for all functionality
        String action = args.length > 0 ? args[0] : "portal";

        if (action.equals("account")) {
            accountService("12345");
        } else if (action.equals("fraud")) {
            fraudDetection("txn-001", 500.0);
        } else if (action.equals("risk")) {
            riskAssessment("txn-001", 500.0);
        } else if (action.equals("portal")) {
            transactionPortal("txn-001", "12345", 500.0);
        } else {
            System.out.println("Unknown action: " + action);
        }
    }

    // Account logic mixed with everything else
    public static void accountService(String accountId) {
        System.out.println("=== Account Service ===");
        if (!accounts.containsKey(accountId)) {
            System.out.println("Account not found!");
            return;
        }
        System.out.println("Account ID: " + accountId);
        System.out.println("Balance: $" + accounts.get(accountId));
        System.out.println("Status: ACTIVE");
    }

    // Fraud detection glued in here
    public static boolean fraudDetection(String txnId, double amount) {
        System.out.println("=== Fraud Detection ===");
        boolean fraud = amount > 10000 || new Random().nextBoolean(); // totally arbitrary
        System.out.println("Transaction " + txnId + " fraud check result: " + fraud);
        return fraud;
    }

    // Risk assessment also stuffed here
    public static int riskAssessment(String txnId, double amount) {
        System.out.println("=== Risk Assessment ===");
        int score = (int)(amount / 100) + new Random().nextInt(50); // nonsense logic
        System.out.println("Risk Score: " + score);
        return score;
    }

    // The "portal" mixes all services together
    public static void transactionPortal(String txnId, String accountId, double amount) {
        System.out.println("=== Transaction Portal ===");

        // Call account service inline
        accountService(accountId);

        // Fraud detection inline
        boolean fraud = fraudDetection(txnId, amount);
        if (fraud) {
            System.out.println("Transaction flagged as FRAUD. Rejecting.");
            return;
        }

        // Risk check inline
        int risk = riskAssessment(txnId, amount);
        if (risk > 80) {
            System.out.println("Transaction HIGH RISK. Manual review required.");
            return;
        }

        // Business logic hardcoded
        System.out.println("Transaction APPROVED for account " + accountId + " amount $" + amount);

        // Everything logged to console (no observability)
        System.out.println("=== END TRANSACTION ===");
    }
}
