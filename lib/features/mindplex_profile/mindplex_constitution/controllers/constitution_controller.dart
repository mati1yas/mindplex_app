import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';

class ConstitutionController extends GetxController {
  List<Content> contents = [
    Content(
        type: "p",
        content:
            "<b>Mindplex</b> is a place for human minds and machine minds to connect together and share ideas, thoughts, and opinions."),
    Content(
        type: "p",
        content:
            "We work on the assumption that ideas, thoughts, opinions should stand or fall on their own merits, not on their usefulness to the powerful."),
    Content(
        type: "p",
        content:
            "We believe in freedom of conscience. We believe in open discussion."),
    Content(
        type: "p",
        content:
            "Therefore, we believe that strict policing of content is a solution worse than the problem it solves. It distorts honest discussion with power-games."),
    Content(
        type: "p",
        content:
            "Minds, and mindplexes, can get closer to the truth by a process of striving and struggling and examining ideas. Truth is not given to us ready-made as a set of dogmas. It is impossible to struggle towards truth if you are not allowed to discuss ideas that are wrong."),
    Content(
        type: "p", content: "Therefore, we support your right to be wrong."),
    Content(
        type: "p",
        content:
            "We will take a minimalist approach to moderation, and leave content up if in any way excusable. Ultimately, we will relinquish the power to take down content."),
    Content(
        type: "p",
        content:
            "Generally, we care less about what you say than how you say it:"),
    Content(
        type: "li",
        content:
            "It's ok to say words that appear bad if they're said in a friendly, bantering way."),
    Content(
        type: "li",
        content:
            "It's ok to say words that appear bad if you said it in innocence, not knowing any better."),
    Content(
        type: "li",
        content:
            "It\'s ok to say words that appear bad in a spirit of honest scientific inquiry, considering what might possibly be true."),
    Content(
        type: "li",
        content:
            "We reserve the right to take down harsh words spoken with hostility and an intent to hurt. Treat each other with respect and civility."),
    Content(type: "p", content: "Be nice. If you can't be nice, be funny."),
    Content(
        type: "p",
        content:
            "Be nice to noobs. We all started knowing nothing, then we learned bit-by-bit. Be considerate of anyone at any stage of this process."),
    Content(
        type: "p",
        content:
            "We reserve the right to take down name-calling done in a spirit of hostility without a constructive goal. We will treat all sides equally in this."),
    Content(type: "h1", content: "AIM FOR NEUTRAL, HIGH-QUALITY DISCUSSION"),
    Content(
        type: "p",
        content:
            "We favor no point of view or political or scientific ideology over another. It is our firm belief that it is a mistake to hold firm beliefs. If you want to claim some conspiracy theory or fringe science is true, you are welcome to use Mindplex to present your views, if you do it in a friendly and honest way."),
    Content(
        type: "p",
        content:
            "People who disagree with you will have equal right to reply. Mindplex moderators and administrators will treat all parties equally."),
    Content(
        type: "p",
        content:
            "The rules of Mindplex, including this constitution, will not be perfect for all circumstances. This constitution is a dynamic document to be used as a set of guidelines. The spirit of the constitution trumps the literal meaning. Common sense will guide editorial policy."),
    Content(
        type: "p",
        content:
            "Do not deliberately create hoaxes. This disrupts honest inquiry."),
    Content(
        type: "p",
        content:
            "There is a difference between an argument and an assertion: an argument presents evidence and logic towards a conclusion; an assertion presents a conclusion emphatically. Arguments, that include verifiable (or falsifiable, or otherwise testable) facts are in a stronger position than unverifiable/baseless assertions."),
    Content(
        type: "p",
        content:
            "If backing up your claims with Wikipedia, remember that Wikipedia is a tertiary source, and is as strong as the primary and secondary sources it stands on. Uncited Wikipedia articles, or Wikipedia articles that cite tabloids, are about as reliable as other noise on the internet. Wikipedia articles that cite “nature” are about as reliable as nature."),
    Content(
        type: "p",
        content:
            "Assessing the strength of an argument must be done on a case-by-case basis. No source is 100% reliable. As some guidelines: breaking news reports, tabloids, social media, and claims by commercial enterprises are not reliable; high-impact scientific journals, textbooks, and encyclopedias are pretty reliable."),
    Content(
        type: "p",
        content:
            "Cleverly trying to disrupt the platform to prove a point is disruptive to open discussion. We will intervene in such cases, for example, when a user uses sockpuppet accounts to game the system."),
    Content(
        type: "p",
        content:
            "We know that any online system, such as a blockchain, will be attacked, and our technical architecture must be strong enough to shrug off such attacks. However, we still frown upon them and will use administrative powers."),
    Content(
        type: "p",
        content:
            "Cleverly trying to outsmart editorial rules or this constitution is disruptive to open discussion. We will intervene in such cases."),
    Content(type: "h1", content: "RESOLVING DISPUTES"),
    Content(
        type: "p",
        content:
            "When disputes arise, it’s the job of users, moderators, and administrators to resolve them. (Corollary: it is not your job to “beat” the other guy in the dispute.) When disputes get resolved, Mindplex gets stronger."),
    Content(
        type: "p",
        content:
            "Someone who disagrees with you is not your enemy. Find out what each party thinks, what each party wants, and what outcome would satisfy all parties."),
    Content(
        type: "p",
        content:
            "Assume good faith, even to the point of ridiculousness. This helps disputes get resolved."),
    Content(
        type: "p",
        content:
            "It may be helpful to resolve disputes (especially disputes about bans and content takedowns) by appealing to a panel of moderators."),
    Content(
        type: "p",
        content:
            "Remember that debate and disagreement are about truth-seeking, not about winning and losing. It is good to lose a debate; it means you come away with a wiser, adjusted viewpoint."),
    Content(type: "h1", content: "EMERGENCY TAKEDOWNS"),
    Content(
        type: "p",
        content:
            "We reserve the right to take down content quickly in cases of emergency (especially where content may be illegal) and review the decision later.")
  ];
}
