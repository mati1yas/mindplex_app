import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';

class TermsController extends GetxController {
  List<Content> contents = [
    Content(type: "h1", content: "Mindplex Terms of Service"),
    Content(type: "p", content: "Last Updated Jan 10, 2023"),
    Content(
        type: "p",
        content:
            'Welcome to Mindplex! This agreement (the “Agreement”) between you and Mindplex. (“we”, “us”, “our”) sets out your rights to access and use of mindplex.ai and any other products or services provided by us (the “Service”). If you are accepting this Agreement and using the Services on behalf of a company, organization, government, or other legal entity, you represent and warrant that you are authorized to do so and have the authority to bind such entity to this Agreement. By accessing our Service, you agree that you have read, understood and accepted this Agreement.'),
    Content(
        type: "p",
        content:
            'If we decide to make changes to this Agreement, we will provide notice of those changes by updating the “Last Updated” date above or posting notice on mindplex.ai. Your continued use of the Service will confirm your acceptance of the changes.'),
    Content(type: "h2", content: "Privacy Policy"),
    Content(
        type: "p",
        content:
            "Please refer to our Privacy Policy for information about how we collect, use, and disclose information about you."),
    Content(type: "h2", content: "Eligibility"),
    Content(
        type: "p",
        content:
            "The Service is not targeted toward, nor intended for use by, anyone under the age of 13. You must be at least 13 years of age to access or use of the Service. If you are between 13 and 18 years of age (or the age of legal majority where you reside), you may only access or use the Service under the supervision of a parent or legal guardian who agrees to be bound by this Agreement."),
    Content(type: "h2", content: "Copyright and Limited License"),
    Content(
        type: "p",
        content:
            'We may retain data, text, photographs, images, video, audio, graphics, articles, comments, software, code, scripts, and other content supplied by us, the Mindplex services or our licensors, which we call “Mindplex Content”. Mindplex Content is protected by intellectual property laws, including copyright and other proprietary rights of the United States and foreign countries. Except as explicitly stated in this Agreement, we do not grant any express or implied rights to use Mindplex Content.'),
    Content(
        type: "p",
        content:
            'You are granted a limited, non-exclusive, non-transferable, and non-sublicensable license to access and use the Service and Mindplex Content for your personal use. You retain ownership of and responsibility for Content you create or own ("Your Content"). If you\'re posting anything you did not create yourself or do not own the rights to, you agree that you are responsible for any Content you post; that you will only submit Content that you have the right to post; and that you will fully comply with any third-party licenses relating to Content you post.'),
    Content(type: "h2", content: "Trademark Policy"),
    Content(
        type: "p",
        content:
            '“Mindplex,”, the Mindplex logo and any other product or service names, logos, slogans that may appear on the Service are trademarks of Mindplex Inc.., and, may not be copied, imitated, or used, in whole or in part, unless explicitly permitted or without first receiving written permission from us to do so. The look and feel of mindplex.ai and the Service is protected by copyright © Mindplex Inc. All rights reserved. You may not duplicate, copy, or reuse any portion of the PHP, HTML/CSS, Python, Solidity, and Javascript, or visual design elements or concepts without express written permission.'),
    Content(
        type: "p",
        content:
            'We encourage third-party dapp developers building on top of the Mindplex services to reach out to trademark@mindplex.ai for all branding and licensing questions.'),
    Content(
        type: "p",
        content:
            'All other trademarks, registered trademarks, product names and company names or logos mentioned or used on our Service are the property of their respective owners and may not be copied, imitated, or used, in whole or in part, without the permission of the applicable trademark holder. Reference to any products, services, processes or other information by name, trademark, manufacturer, supplier or otherwise does not constitute or imply endorsement, sponsorship, or recommendation by us.'),
    Content(
        type: "h2", content: "Assumption of Risk, Limitations on Liability"),
    Content(
        type: "li",
        content:
            "1. You accept and acknowledge that there are risks associated with utilizing an Internet-based wallet account service including, but not limited to, the risk of failure of hardware, software and Internet connections, the risk of malicious software introduction, and the risk that third-parties may obtain unauthorized access to information stored within or associated with your Account, including, but not limited to your private key(s) (“Private Key”). You accept and acknowledge that we will not be responsible for any communication failures, disruptions, errors, distortions, or delays you may experience when using the Services, however caused."),
    Content(
        type: "li",
        content:
            "2. We make no representation or warranty of any kind, express or implied, statutory, or otherwise, regarding the contents of the Service, information and functions made accessible through the Service, any hyperlinks to third-party websites and or blockchain solutions, nor for any breach of security associated with the transmission of information through the Service or any website or any kind of blockchain solution linked to by the Service."),
    Content(
        type: "li",
        content:
            "3. We will not be responsible or liable to you for any loss and take no responsibility for and will not be liable to you for any use of our Services, including but not limited to any losses, damages or claims arising from:"),
    Content(
        type: "li",
        content:
            "(a) User error such as forgotten passwords, incorrectly constructed transactions, or mistyped wallet addresses;"),
    Content(type: "li", content: "(b) Server failure or data loss;"),
    Content(type: "li", content: "(c) Corrupted Account files;"),
    Content(type: "li", content: "(d) Unauthorized access to applications;"),
    Content(
        type: "li",
        content:
            "(e) Any unauthorized third-party activities, including without limitation the use of viruses, phishing, brute forcing or other means of attack against the Service or Services."),
    Content(
        type: "li",
        content:
            "4. We make no warranty that the Service or the server that makes it available, are free of viruses or errors, that its content is accurate, that it will be uninterrupted, or that defects will be corrected. We will not be responsible or liable to you for any loss of any kind, from action taken, or taken in reliance on material, or information, contained on the Service."),
    Content(
        type: "li",
        content:
            "5. Subject to “Agreement” section any and all indemnities, warranties, terms, and conditions (whether express or implied) are hereby excluded to the fullest extent permitted under EU law."),
    Content(
        type: "li",
        content:
            "6. We will not be liable, in contract, or tort (including, without limitation, negligence), other than where we have been fraudulent."),
    Content(type: "h2", content: "Agreement to hold Mindplex Inc. harmless"),
    Content(
        type: "li",
        content:
            "1. You agree to hold harmless Mindplex Inc. (and each of our officers, directors, members, employees, agents, and affiliates) from any claim, demand, action, damage, loss, cost, or expense, including without limitation reasonable legal fees, arising out, or relating to:"),
    Content(
        type: "li",
        content: "Your use of, or conduct in connection with, our Services;"),
    Content(
        type: "li",
        content: "Your violation of any term in this Agreement; or"),
    Content(
        type: "li",
        content: "Violation of any rights of any other person or entity."),
    Content(
        type: "li",
        content:
            "2. If you are obligated to indemnify us, we will have the right, in our sole discretion, to control any action or proceeding (at our expense) and determine whether we will pursue a settlement of any action or proceeding."),
    Content(
        type: "h2",
        content: "No Liability for Third-Party Services and Content"),
    Content(
        type: "li",
        content:
            "1. In using our Services, you may view content or utilize services provided by third parties, including links to web pages and services of such parties (“Third-Party Content”). We do not control, endorse, or adopt any Third-Party Content and will have no responsibility for Third-Party Content including, without limitation, material that may be misleading, incomplete, erroneous, offensive, indecent, or otherwise objectionable in your jurisdiction. In addition, your dealings or correspondence with such third parties are solely between you and the third parties. We are not responsible or liable for any loss or damage of any sort incurred because of any such dealings and you understand that your use of Third-Party Content, and your interactions with third parties, is at your own risk."),
    Content(type: "h2", content: "Account Registration"),
    Content(
        type: "li",
        content:
            "1. You need to use a Mindplex Reputation Escrow provided by us to utilize your MPXR tokens which are non liquid and non transferable. To access the Mindplex Reputation Escrow, you need to create a user account (Account) on Mindplex. On the other hand, to utilize the MPX token, which is the liquid and transferable token, you can create your preferred blockchain wallet independently of the service and then connect it with Mindplex Escrow. The Mindplex Escrow will then provide a deposit or withdraw service to or from our platform, only from the Mindplex platform. When you create an Account, you are strongly advised to take the following precautions, as failure to do so may result in loss of access to, and/or control over, your Account:"),
    Content(
        type: "li", content: "(a) Provide accurate and truthful information;"),
    Content(
        type: "li",
        content:
            "(b) Maintain the security of your Account by protecting your Account password and access to your computer and your Account;"),
    Content(
        type: "li",
        content:
            "(c) Promptly notify us if you discover or otherwise suspect any security breaches related to your Account."),
    Content(
        type: "li",
        content:
            "2. You hereby accept and acknowledge that you take responsibility for all activities that occur under your Account and accept all risks of any authorized or unauthorized access to your Account, to the maximum extent permitted by law."),
    Content(
        type: "li",
        content:
            "3. You acknowledge and understand that cryptography is a progressing field. Advances in code cracking or technical advances such as but not limited to the development of quantum computers may present risks to the Services that you use and your Account, which could result in the theft or loss of your property. By using the Service or accessing Mindplex Content, you acknowledge these inherent risks."),
    Content(type: "h3", content: "1. The Services"),
    Content(
        type: "li",
        content:
            "As described in more detail below, the Services, among other things, provide software that facilitates the submission of Mindplex transaction data to the user's wallet without requiring you to access the native blockchain command line interface."),
    Content(type: "h3", content: "2. Account and Private Keys"),
    Content(
        type: "li",
        content:
            "Should you agree to create a User Account through our Service, we will create an account on the Mindplex Reputation Escrow after you connect your preferred wallet. We will have every and all right to manage your MPXR token, which is your reputation token on the Mindplex ecosystem. The management here includes; reward (issuing) MPXR, punish (burning) MPXR, temporarily locking MPXR during voting procedures, or deciding token transfer time from your user account to the Mindplex Reputation Escrow (from Offchain to our smart contract). In the case where you delete your Mindplex User Account, your MPXR tokens will still stay in the Mindplex Reputation Escrow so you can use them in other ecosystems."),
    Content(
        type: "li",
        content:
            "As for your MPX token, you can use your preferred wallet which should generate a cryptographic private and public key pair that are provided solely to you and completely owned by you. However, after connecting that wallet to our service, we do not store passwords or Private Keys for you. We never have access to your Private Key and do not custody any Private Keys on your behalf, and therefore, assume no responsibility for the management of the Private Key tied to your MPX Account. The Private Key uniquely matches the Account name and must be used in connection with the Account to authorize the transfer of MPX from that Account. You are solely responsible for maintaining the security of your Private Keys. You must keep your Private Key access information secure. Failure to do so may result in the loss of control of MPX associated with your Account."),
    Content(type: "h3", content: "3. No Password Retrieval"),
    Content(
        type: "li",
        content:
            "We do not receive or store your Blockchain Account password or Private Keys. Your Private Key is your own and you are solely responsible for their safekeeping. We cannot assist you with Account password retrieval, reset, or recovery. You are solely responsible for remembering your Account password. If you have not safely stored a backup of any Account and password pairs maintained in your Account, you accept and acknowledge that any MPX you have associated with such an Account will become permanently inaccessible if you do not have your Wallet Account password. For the MPXR token which is kept in our Mindplex Reputation Escrow, we recommend that you store your Mindplex User Account in a secure location. However, if you lose this (Your Mindplex User Account), we will be able to assist you with account password retrieval, reset, or recovery. This might help you to reclaim your MPXR token from our Mindplex Reputation Escrow. However, we will not guarantee a hundred percent MPXR token recovery in every case."),
    Content(type: "h3", content: "4. Transactions"),
    Content(
        type: "li",
        content:
            "All proposed Mindplex smart contract transactions must be confirmed and recorded in the Polygon and Ethereum blockchain (a peer-to-peer network), which is not owned, controlled, or operated by us. The Polygon and Ethereum blockchain is operated by a decentralized network of independent third parties. We have no control over the Polygon and Ethereum blockchain and therefore cannot and will not ensure that any transaction details you submit via the Services will be confirmed on the Polygon and Ethereum blockchain. You acknowledge and agree that the transaction details you submit via the Services may not be completed, or may be substantially delayed, by the Polygon and Ethereum blockchain. You may use the Services to submit these details to the Polygon and Ethereum blockchain."),
    Content(
        type: "h3", content: "5. No Storage or Transmission of MPX and MPXR"),
    Content(
        type: "li",
        content:
            "In any of its forms is an intangible, digital asset controlled by you. These assets exist only by virtue of the ownership record maintained on the Polygon and Ethereum blockchain. However, for MPX, the Service manages the asset if it is stored on the Mindplex Escrow including, send, or receive MPX. For MPXR, the service manages the asset in the ways described in Section 9.2. Any transfer of permanent or temporary title that might occur in any of these tokens occurs on the Polygon and Ethereum blockchain and not within the Services. We do not guarantee that the Service can affect the transfer of title or right in any tokens."),
    Content(type: "h3", content: "6. Relationship"),
    Content(
        type: "li",
        content:
            "Nothing in this Agreement is intended to nor shall create any partnership, joint venture, agency, consultancy, or trusteeship, between you and us."),
    Content(type: "h3", content: "7. Accuracy of Information"),
    Content(
        type: "li",
        content:
            "You represent and warrant that any information you provide via the Services is accurate and complete. You accept and acknowledge that we are not responsible for any errors or omissions that you make in connection with any Polygon and Ethereum blockchain transaction initiated via the Services, for instance, if you mistype an Account name or otherwise provide incorrect information. We strongly encourage you to review your transaction details carefully before completing them via the Services, because due to the nature of the blockchain technology the transactions are irreversible."),
    Content(type: "h3", content: "8. No Cancellations or Modifications"),
    Content(
        type: "li",
        content:
            "Once transaction details have been submitted to the Polygon and Ethereum blockchain via the Services, The Services cannot assist you to cancel or otherwise modify your transaction details. We have no control over the Polygon and Ethereum blockchain and do not have the ability to facilitate any cancellation or modification requests. However, in cases like Paid content request or Content creator’s tip,"),
    Content(type: "h3", content: "9. Taxes"),
    Content(
        type: "li",
        content:
            "It is your responsibility to determine what, if any, taxes apply to the transactions for which you have submitted transaction details via the Services, and it is your responsibility to report and remit the correct tax to the appropriate tax authority. You agree that we are not responsible for determining whether taxes apply to your Polygon and Ethereum blockchain transactions or for collecting, reporting, withholding, or remitting any taxes arising from any Polygon and Ethereum blockchain transactions."),
    Content(type: "h2", content: "Fees for Using the Services"),
    Content(
        type: "li",
        content:
            "Fees Creating an Account. We do not currently charge fees for any Services in connection with the creation of Accounts, however we reserve the right to do so in future, and in such case any applicable fees will be displayed prior to you using any Service to which a fee applies."),
    Content(
        type: "h2", content: "No Right to Cancel and/or Reverse Transactions"),
    Content(
        type: "li",
        content:
            "If you use a Service to which are transacted, you will not be able to change your mind once you have confirmed that you wish to proceed with the Service or transaction."),
    Content(type: "h2", content: "Discontinuation of Services"),
    Content(
        type: "li",
        content:
            "1. We may, in our sole discretion and without cost to you, with or without prior notice and at any time, modify or discontinue, temporarily or permanently, any portion of our Services, you are solely responsible for storing, outside of the Services, a backup of any Account and Private Key that you maintain in your Account."),
    Content(
        type: "li",
        content:
            "2. If you do not maintain a backup of your preferred wallet Account data outside of the Services, you may not be able to access MPX associated with any Account maintained in your Account if we discontinue or deprecate the Services."),
    Content(type: "h2", content: "Suspension or Termination of Service"),
    Content(
        type: "li",
        content:
            "We may suspend or terminate your access to the Services in our sole discretion, immediately and without prior notice, and delete or deactivate your mindplex.ai account and all related information and files in such without cost to you, including, for instance, if you breach any term of this Agreement. In the event of termination, your access to the MPX funds in your account will require you access to the Polygon and Ethereum blockchain via the command line API or third party tool, and will require you to have access to your backup of your Account data including your Account and Private Keys. Whatever MPX funds you have on our Mindplex Escrow will be transferred (all the eligible funds) to your wallet. Regarding the MPXR, the asset will stay in the Mindplex reputation escrow."),
    Content(type: "h2", content: "User Conduct"),
    Content(
        type: "li",
        content:
            "When accessing or using the Services, you agree that you will not commit any unlawful act, and that you are solely responsible for your conduct while using our Services. Without limiting the generality of the foregoing, you agree that you will not:"),
    Content(
        type: "li",
        content:
            "1. Use our Services in any manner that could interfere with, disrupt, negatively affect, or inhibit other users from fully enjoying our Services, or that could damage, disable, overburden, or impair the functioning of our Services in any manner;"),
    Content(
        type: "li",
        content:
            "2. Use our Services to pay for, support or otherwise engage in any activity prohibited by law, including, but not limited to illegal gambling, fraud, money-laundering, or terrorist financing activities."),
    Content(
        type: "li",
        content:
            "3. Use or attempt to use another user’s Account without authorization;"),
    Content(
        type: "li",
        content:
            "4. Attempt to circumvent any content filtering techniques we employ, or attempt to access any service or area of our Services that you are not authorized to access;"),
    Content(
        type: "li",
        content:
            "5. Introduce to the Services any virus, malware, Trojan, worms, logic bombs or other harmful material;"),
    Content(
        type: "li",
        content:
            "6. Encourage or induce any third-party to engage in any of the activities prohibited under this Section;"),
    Content(
        type: "li",
        content:
            "7. Use our services to promote third-party platforms or to promote each other without our written permission."),
    Content(
        type: "h2", content: "Copyright Complaints, the DMCA, and Takedowns"),
    Content(
        type: "li",
        content:
            "1. We will respond to legitimate requests under the Digital Millennium Copyright Act (\"DMCA\"), and we retain the right to remove access to user content provided via the Service that we deem to be infringing the copyright of others. If you become aware of user content on the Service that infringes your copyright rights, you may submit a properly formatted DMCA request (see 17 U.S.C. § 512) to Mindplex, Inc."),
    Content(
        type: "li",
        content:
            "Misrepresentations of infringement can result in liability for monetary damages. You may want to consult an attorney before taking any action pursuant to the DMCA. A DMCA request can be sent to us via the contact information below:"),
    Content(type: "li", content: "Copyright Agent"),
    Content(type: "li", content: "Mindplex, Inc."),
    Content(type: "li", content: "copyright@mindplex.ai"),
    Content(
        type: "li",
        content:
            "Please send to our Copyright Agent the following information:"),
    Content(
        type: "li",
        content:
            "The electronic or physical signature of the owner of the copyright or the person authorized to act on the owner's behalf;"),
    Content(
        type: "li",
        content:
            "Identification of the copyrighted work claimed to have been infringed, or a representative list of such works;"),
    Content(
        type: "li",
        content:
            "The URL or Internet location of the materials claimed to be infringing or to be the subject of infringing activity, or information reasonably sufficient to permit us to locate the material;"),
    Content(
        type: "li",
        content: "Your name, address, telephone number, and email address;"),
    Content(
        type: "li",
        content:
            "A statement by you that you have a good faith belief that the disputed use of the material is not authorized by the copyright owner, its agent, or the law; and"),
    Content(
        type: "li",
        content:
            "A statement by you, made under penalty of perjury, that the above"),
    Content(
        type: "li",
        content:
            "2. Your right to file a counter-notice. If you believe your user content was wrongly removed due to a mistake or misidentification of the material, you can send a counter-notice to our Copyright Agent (contact information provided above) that includes the following:"),
    Content(type: "li", content: "Your physical or electronic signature;"),
    Content(
        type: "li",
        content:
            "Identification of the material that has been removed or to which access has been disabled and where the material was located online before it was removed or access to it was disabled;"),
    Content(
        type: "li",
        content:
            "A statement by you, under penalty of perjury, that you have a good faith belief that the material was removed or disabled because of mistake or misidentification of the material to be removed or disabled; and"),
    Content(
        type: "li",
        content:
            "Your name, address, and telephone number, and a statement that you consent to the jurisdiction of federal district court for the judicial district in which the address is located, or if your address is outside of the United States, for any judicial district in which the service provider may be found, and that you will accept service of process from the person who provided notification under DMCA 512 subsection (c)(1)(c) or an agent of such person."),
    Content(
        type: "li",
        content:
            "Upon receiving a counter-notice we will forward it to the complaining party and tell them we will restore your content within 10 business days. If that party does not notify us that they have filed an action to enjoin your use of that content on the Service before that period passes, we will consider restoring your user content to the site."),
    Content(
        type: "li",
        content:
            "It is our policy to deny use of the Service to users we identify as repeat infringers. We apply this policy at our discretion and in appropriate circumstances, such as when a user has repeatedly been charged with infringing the copyrights or other intellectual property rights of others."),
    Content(type: "h2", content: "Indemnity"),
    Content(
        type: "li",
        content:
            "All the things you do and all the information you submit or post to the Service remain your responsibility. Indemnity is basically a way of saying that you will not hold us legally liable for any of your content or actions that infringe the law or the rights of a third party or person in any way."),
    Content(
        type: "li",
        content:
            "Specifically, you agree to hold us, our affiliates, officers, directors, employees, agents, and third-party service providers harmless from and defend them against any claims, costs, damages, losses, expenses, and any other liabilities, including attorneys’ fees and costs, arising out of or related to your access to or use of the Service, your violation of this user agreement, and/or your violation of the rights of any third-party or person."),
    Content(type: "h2", content: "Disclaimers"),
    Content(
        type: "li",
        content:
            "To the fullest extent permitted by applicable law, the Service and the Mindplex Content are provided on an “as is” and “as available” basis, without warranties of any kind, either express or implied, including, without limitation, implied warranties of merchantability, fitness for a particular purpose, title and non-infringement and any warranties implied by any course of performance or usage of trade. The company does not represent or warrant that the Service and the Mindplex Content: (a) will be secure or available at any time or location; (b) are accurate, complete, reliable, current, or error-free or that any defects or errors will be corrected; and (c) are free of viruses or other harmful components. Your use of the Service and Mindplex Content is solely at your own risk. Some jurisdictions do not allow the disclaimer of implied terms in contracts with consumers, so some or all of the disclaimers in this Section may not apply to you."),
    Content(type: "h2", content: "Limitation of liability"),
    Content(
        type: "li",
        content:
            "To the fullest extent permitted by applicable law, in no event shall Mindplex Inc. or the any related party to Mindplex Inc., that includes but is not limited to, subsidiaries, vendors, or contractors, be liable for any special, indirect, incidental, consequential, exemplary or punitive damages, or any other damages of any kind, including, but not limited to, loss of use, loss of profits or loss of data, whether in an action in contract, tort (including, but not limited to, negligence) or otherwise, arising out of, or in any way connected with, the use of, or inability to use, the Service or the Mindplex Content. To the fullest extent permitted by applicable law, in no event shall the aggregate liability of Mindplex, Inc. or any related party, whether in contract, warranty, tort (including negligence, whether active, passive or imputed), product liability, strict liability or other theory, arising out of or relating to the use of or inability to use of the Service"),
    Content(
        type: "li",
        content:
            "Some jurisdictions do not allow the exclusion or limitation of certain damages, so some or all of the exclusions and limitations in this Section may not apply to you."),
    Content(type: "h2", content: "Modifications to the Service"),
    Content(
        type: "li",
        content:
            "We reserve the right to modify or discontinue, temporarily or permanently, the Service, or any features or portions of the Service, without prior notice. You agree that we will not be liable for any modification, suspension, or discontinuance of the Service."),
    Content(type: "h2", content: "Disputes"),
    Content(
        type: "li",
        content:
            "1. Any controversy, claim or dispute (“Dispute”) arising out of or related to this Terms of Service, shall be dealt with as follows:  Each Dispute initially shall be brought for resolution before a committee consisting of two (2) representatives of each of the parties. If the committee is unable to resolve a Dispute within ten (10) working days, then the Dispute shall be escalated to a separate committee consisting of one (1) senior officer of each party.  If this second committee is unable to resolve the Dispute within five (5) working days, then the Dispute may be referred to formal arbitration pursuant to The Netherlands Arbitration Ordinance and to the extent applicable, the International Commercial Arbitration Act R.S.B.C. 1996 c 223, and judgment upon the award rendered by the arbitrator may be entered in any court having jurisdiction thereof."),
    Content(
        type: "li",
        content:
            "2. You may refer a Dispute to arbitration by serving written notice of its intention to arbitrate.  Arbitration of the Dispute shall be conducted by a single arbitrator to be mutually agreed to by the parties within three (3) working days following the referral of the Dispute to arbitration.  The arbitrator shall have substantial experience in arbitrating social media disputes. If the parties are unable to mutually agree upon an arbitrator, either party may apply to a court in The Netherlands jurisdiction for the appointment of such arbitrator."),
    Content(
        type: "li",
        content:
            "3 You agree to co-operate promptly and fully with Mindplex Inc. with respect to all aspects of arbitration including, without limitation, appointment of the arbitrator and compliance with any requests or orders of the arbitrator. All arbitration shall take place in The Netherlands.  All arbitration shall be conducted in the English language.  Each party shall pay an equal share of the costs of any arbitration.  Any award of the arbitrator shall be final and binding on the parties."),
    Content(
        type: "li",
        content:
            "4. No Class Arbitrations, Class Actions or Representative Actions. You agree that any dispute is personal to you and Mindplex Inc. and that any such dispute will be resolved solely through individual arbitration and will not be brought as a class arbitration, class action or any other type of representative proceeding. Neither party agrees to class arbitration or to an arbitration in which an individual makes and attempt to resolve a dispute as a representative of another individual or group of individuals. Further, you and Mindplex Inc. agree that a dispute cannot be brought as a class, or other type of representative action, whether within or outside of arbitration, or on behalf of any other individual or group of individuals."),
    Content(
        type: "li",
        content:
            "5. Severability. If any term, clause, or provision of this Section is held invalid or unenforceable, it will be so held to the minimum extent required by law and all other terms, clauses or provisions will remain valid and enforceable. Further, the waivers set forth in Section 4 are severable from the other provisions of this Agreement and will remain valid and enforceable, except as prohibited by applicable law."),
    Content(type: "h2", content: "Applicable Law and Venue"),
    Content(
        type: "li",
        content:
            "This Agreement and your access to and use of the Service and the Mindplex Content will be governed by, and construed in accordance with, the laws of The Netherlands, without resort to its conflict of law provisions. To the extent the arbitration provision in Section “Disputes” does not apply and the Dispute cannot be heard in small claims court, you agree that any action at law or in equity arising out of, or relating to, this Agreement shall be filed only in the courts located in The Netherlands and you hereby irrevocably and unconditionally consent and submit to the exclusive jurisdiction of such courts over any suit, action or proceeding arising out of this Agreement."),
    Content(type: "h2", content: "Termination"),
    Content(
        type: "li",
        content:
            "We reserve the right, without notice and in our sole discretion, to terminate your license to access and use of the Service, which includes, mindplex.ai, and to block or prevent your future access to, and use of, the Service that we provide."),
    Content(type: "h2", content: "Severability"),
    Content(
        type: "li",
        content:
            "If any term, clause, or provision of this Agreement is deemed to be unlawful, void or for any reason unenforceable, then that term, clause or provision shall be deemed severable from this Agreement and shall not affect the validity and enforceability of any remaining provisions."),
    Content(type: "h2", content: "Changes"),
    Content(
        type: "li",
        content:
            "This Agreement is the entire agreement between you and us concerning the Service. It supersedes all prior or contemporaneous agreements between you and us. We may modify this user agreement at any time. If we make changes to this agreement that materially affect your rights, we will provide notice and keep this edition available as an archive on mindplex.ai. By continuing to use the Services after a change to this agreement, you agree to those changes."),
    Content(type: "h2", content: "Contact Information"),
    Content(
        type: "li",
        content:
            "Notices to Mindplex, Inc. should be directed to legal@mindplex.ai."),
  ];
}
